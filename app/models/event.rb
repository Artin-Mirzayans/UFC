class Event < ApplicationRecord
  has_many :fights, -> { order(position: :asc) }, dependent: :destroy
  has_many :reds, through: :fights, source: :red
  has_many :blues, through: :fights, source: :blue
  has_many :methodpredictions
  has_many :distancepredictions
  has_many :user_event_budgets, dependent: :destroy

  validates :apiname, presence: true
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validates :red, presence: true
  validates :blue, presence: true
  validates :category, presence: true

  enum status: %i[UPCOMING INPROGRESS CONCLUDED]
  after_initialize :set_default_status, if: :new_record?
  after_update :schedule_cards

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

  def schedule_cards
    if self.category == "PPV" && saved_change_to_attribute?(:early)
      schedule_card(self.id, "EARLY", self.date, self.early)
    end
    if saved_change_to_attribute?(:prelims)
      schedule_card(self.id, "PRELIMS", self.date, self.prelims)
    end
    if saved_change_to_attribute?(:main)
      schedule_card(self.id, "MAIN", self.date, self.main)
    end
  end

  def schedule_card(event_id, card, card_date, card_time)
    @card_datetime =
      card_date.to_time +
        Time.parse(card_time.strftime("%H:%M")).seconds_since_midnight.seconds
    LockCardJob.set(wait_until: @card_datetime).perform_later(event_id, card)
  end

  # def started?
  #   if self.category == "PPV"
  #     Time.now.strftime("%H:%M") > self.early.strftime("%H:%M")
  #   else
  #     Time.now.strftime("%H:%M") > self.prelims.strftime("%H:%M")
  #   end
  # end

  # def self.get_upcoming_event
  #   Event.UPCOMING.find_by(date: Date.today)
  # end
end
