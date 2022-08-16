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

  validate :update_timer?
  validate :event_locked?

  def update_timer?
  end

  def event_locked?
    unless self.event.status == "UPCOMING"
      errors.add(:status, "Predictions are Locked.")
    end
  end
end
