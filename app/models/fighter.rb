class Fighter < ApplicationRecord
    
    def fights
        Fight.where(red_id: self.id).or(Fight.where(blue_id: self.id))
    end

end