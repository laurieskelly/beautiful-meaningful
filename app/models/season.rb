class Season < ActiveRecord::Base

  has_many :episodes, primary_key: :episode_number
  
  self.primary_key = 'year'
  
  validates :year, {presence: true, uniqueness: true}

end
