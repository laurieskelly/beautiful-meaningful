class Season < ActiveRecord::Base

  has_many :episodes 

  self.primary_key = 'year'
  
end
