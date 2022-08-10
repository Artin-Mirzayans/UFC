class Fighter < ApplicationRecord
  has_many :fights
  has_many :events, through: :fights
  def fights
    Fight.where(red_id: self.id).or(Fight.where(blue_id: self.id))
  end
end
