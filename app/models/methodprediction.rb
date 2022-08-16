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

  enum method: %i[ANY KNOCKOUT SUBMISSION DECISION]

  def update_timer?
  end

  def event_locked?
    unless self.event.status == "UPCOMING"
      errors.add(:status, "Predictions are Locked.")
    end
  end
end
