class Distanceprediction < ApplicationRecord
  belongs_to :user
  belongs_to :fight
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :fight_id, presence: true
  validates :distance, inclusion: [true, false]
  validates :distance, exclusion: [nil]
  validates :line, presence: true
  validates :wager,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 20
            }
  validates :is_correct, inclusion: [true, false]

  validate :update_timer?
  validate :event_locked?

  def update_timer?
    if !self.new_record? && 5.minute.ago > self.created_at
      errors.add(:created_at, "You cannot change your prediction anymore.")
      return false
    end
    return true
  end

  def event_locked?
    unless self.event.status == "UPCOMING"
      errors.add(:status, "Predictions are Locked.")
    end
  end
end
