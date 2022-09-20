class Event < ApplicationRecord
  has_many :fights, -> { order(position: :asc) }, dependent: :destroy
  has_many :reds, through: :fights, source: :red
  has_many :blues, through: :fights, source: :blue
  has_many :methodpredictions
  has_many :distancepredictions
  has_many :user_event_budgets, dependent: :destroy

  has_one_attached :red_image
  has_one_attached :blue_image

  validates :apiname, presence: true
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validates :red, presence: true
  validates :blue, presence: true
  validates :category, presence: true

  enum status: %i[UPCOMING INPROGRESS CONCLUDED]
  after_initialize :set_default_status, if: :new_record?

  def fighters
    Fighter.where(id: self.reds.pluck(:id) + self.blues.pluck(:id))
  end

  def set_default_status
    self.status ||= :UPCOMING
  end

  def get_user_budget(user)
    self.user_event_budgets.find_by(user: user)
  end

  def received_all_results?
    @fights = self.fights
    @fight = @fights.detect { |fight| fight.result.nil? }
    errors.add(:name, "Waiting on all fight results.") if !@fight.nil?
  end

  def user_predicted_fights(user)
    self
      .fights
      .joins(:methodpredictions)
      .where(methodpredictions: { user: user }) +
      self
        .fights
        .joins(:distancepredictions)
        .where(distancepredictions: { user: user })
  end

  def schedule_cards(event_changes)
    if self.category == "PPV" && event_changes.has_key?("early")
      schedule_card(self, "EARLY", self.date, self.early)
    end
    if event_changes.has_key?("prelims")
      schedule_card(self, "PRELIMS", self.date, self.prelims)
    end
    if event_changes.has_key?("main")
      schedule_card(self, "MAIN", self.date, self.main)
    end
    if event_changes[:category].present?
      if event_changes[:category][1] == "FN" && early_job_id.present?
        DelayedJobs.find(self.early_job_id).destroy
        self.update(early: nil, early_job_id: nil)
      end
    end
  end

  def schedule_card(event, card, card_date, card_time)
    @card_datetime =
      Time.zone.parse(
        "#{card_date.strftime("%F")} #{card_time.strftime("%H:%M")}"
      )
    job =
      LockCardJob.set(wait_until: @card_datetime).perform_later(event.id, card)

    if job.successfully_enqueued?
      if event.existing_job?(card.downcase)
        job_to_destroy =
          DelayedJobs.find_by(id: event.get_job_id(card.downcase))
        job_to_destroy.destroy unless job_to_destroy.nil?
      end
      event.update("#{card.downcase}_job_id": job.provider_job_id)
    end
  end

  def existing_job?(card)
    card_job_id = card + "_job_id"
    self.attributes[card_job_id].present?
  end

  def get_job_id(card)
    card_job_id = card + "_job_id"
    self.attributes[card_job_id]
  end
end
