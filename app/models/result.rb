class Result < ApplicationRecord
  belongs_to :fight
  belongs_to :fighter

  validates :fighter_id, presence: true
  validates :method, presence: true

  enum method: %i[KNOCKOUT SUBMISSION DECISION DRAW DQ NC]
end
