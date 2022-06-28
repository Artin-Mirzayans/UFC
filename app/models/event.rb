class Event < ApplicationRecord

after_initialize :set_default_status, :if => :new_record?

def set_default_status
  self.status ||= "Upcoming"
end

end