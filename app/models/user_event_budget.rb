class UserEventBudget < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :budget, presence: true

  after_initialize :set_budget, if: :new_record?

  def set_budget
    self.budget = self.event.budget
  end

  def set_default_wager(user, event)
    if event.budget >= 250
      default = 50
    else
      default = 30
    end
    if self.budget >= default
      return default
    else
      return self.budget
    end
  end

  def sufficient_funds?(difference)
    (self.budget + difference) >= 0
  end

  def update_winnings(winnings)
    self.update(winnings: self.winnings += winnings)
  end

  def refund(wager)
    self.increase_budget(wager)
    self.decrease_wagered(wager)
  end

  def increase_budget(wager)
    self.update(budget: self.budget += wager)
  end

  def decrease_budget(wager)
    self.update(budget: self.budget -= wager)
  end

  def increase_wagered(wager)
    self.update(wagered: self.wagered += wager)
  end

  def decrease_wagered(wager)
    self.update(wagered: self.wagered -= wager)
  end
end
