class Event < ApplicationRecord
  has_many :fights
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  after_initialize :set_default_status, :if => :new_record?

def set_default_status
  self.status ||= "Upcoming"
end

end