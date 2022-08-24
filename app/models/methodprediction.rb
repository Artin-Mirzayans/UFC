class Methodprediction < ApplicationRecord
  belongs_to :user
  belongs_to :fight
  belongs_to :fighter
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :fighter_id, presence: true
  validates :fight_id, presence: true
  validates :method, presence: true
  validates :line, presence: true

  validate :update_timer?
  validate :event_locked?

  enum method: %i[
         red_any
         red_knockout
         red_submission
         red_decision
         blue_any
         blue_knockout
         blue_submission
         blue_decision
       ]

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
