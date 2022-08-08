class Methodprediction < ApplicationRecord
    belongs_to :user
    belongs_to :fight
    belongs_to :fighter
    belongs_to :event

    validates :user_id, presence: true
    validates :fighter_id, presence: true
    validates :fight_id, presence: true
    validates :method, presence: true
    validates :line, presence: true

    validate :prediction_allowed

    enum method: [:ANY, :KNOCKOUT, :SUBMISSION, :DECISION]

    def prediction_allowed
        errors.add(:status, "Predictions are Locked.") unless self.event.status == "UPCOMING"
    end

end