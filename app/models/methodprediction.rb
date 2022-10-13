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
  validates :wager,
            presence: true
  validates :is_correct, inclusion: [true, false]

  validate :validate_budget
  validate :update_timer?
  validate :fight_locked?

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

  after_destroy :refund_wager

  def update_timer?
    if !self.new_record? && 5.minute.ago > self.created_at
      errors.add(:base, "Prediction is Locked")
      return false
    end
    return true
  end

  def fight_locked?
    unless !self.fight.locked? && !self.event.CONCLUDED?
      errors.add(:base, "Fight is locked")
    end
  end

  def validate_budget
    unless (self.wager.is_a? Integer) && self.wager >= 20
      errors.add(:base, "Check Budget - Minimum Wager is $20")
    end
  end

  def refund_wager
    self.user.user_event_budgets.find_by(event: self.event).refund(self.wager)
  end
end
