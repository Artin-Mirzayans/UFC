class Odd < ApplicationRecord
  belongs_to :fight

  def posted?(bet)
    self.attributes[bet].present?
  end

  def retrieve(bet)
    self.attributes[bet]
  end
end
