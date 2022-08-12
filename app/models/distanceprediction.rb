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

  validate :prediction_allowed

  def prediction_allowed
    unless self.event.status == "UPCOMING"
      errors.add(:status, "Predictions are Locked.")
    end
  end
end
