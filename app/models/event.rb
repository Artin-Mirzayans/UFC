class Event < ApplicationRecord
  has_many :fights, -> {order(position: :asc)}
  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validates :category, presence: true

  enum status: [:UPCOMING, :INPROGRESS, :CONCLUDED]
  after_initialize :set_default_status, :if => :new_record?

def set_default_status
  self.status ||= :UPCOMING
end

end