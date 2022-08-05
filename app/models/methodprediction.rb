class Methodprediction < ApplicationRecord
    belongs_to :user
    belongs_to :fight
    belongs_to :fighter

    validates :user_id, presence: true
    validates :fighter_id, presence: true
    validates :fight_id, presence: true
    validates :method, presence: true
    validates :line, presence: true

    enum method: [:ANY, :KNOCKOUT, :SUBMISSION, :DECISION]

end