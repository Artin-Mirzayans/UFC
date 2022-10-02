class Fighter < ApplicationRecord
  before_create :strip_newline
  before_update :strip_newline
  def fights
    Fight.where(red_id: self.id).or(Fight.where(blue_id: self.id))
  end

  def strip_newline
    self.name = self.name.strip
  end

  def events
    Event.where(id: self.fights.pluck(:event_id))
  end
end
