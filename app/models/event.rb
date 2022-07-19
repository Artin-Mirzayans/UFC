class Event < ApplicationRecord
  has_many :fights, -> {order(position: :asc)}
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validates :category, presence: true

  enum status: [:upcoming, :inprogress, :concluded]
  after_initialize :set_default_status, :if => :new_record?

def set_default_status
  self.status ||= :upcoming
end

end