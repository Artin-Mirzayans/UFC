class Fighter < ApplicationRecord
  before_update :strip_newline
  def fights
    Fight.where(red_id: self.id).or(Fight.where(blue_id: self.id))
  end

  validates :name, uniqueness: true
  validates :name, presence: true

  def strip_newline
    self.name = self.name.strip
  end

  def events
    Event.where(id: self.fights.pluck(:event_id))
  end
end
