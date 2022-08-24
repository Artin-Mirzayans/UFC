class Event < ApplicationRecord
  has_many :fights, -> { order(position: :asc) }, dependent: :destroy
  has_many :reds, through: :fights, source: :red
  has_many :blues, through: :fights, source: :blue
  has_many :methodpredictions
  has_many :distancepredictions
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validates :category, presence: true

  enum status: %i[UPCOMING INPROGRESS CONCLUDED]
  after_initialize :set_default_status, if: :new_record?

  def fighters
    Fighter.where(id: self.reds.pluck(:id) + self.blues.pluck(:id))
  end

  def set_default_status
    self.status ||= :UPCOMING
  end

  def received_all_results?
    @fights = self.fights
    @fight = @fights.detect { |fight| fight.result.nil? }
    errors.add(:name, ": Waiting on all fight results") if !@fight.nil?
  end
end
