class Season < ActiveRecord::Base

  has_many :episodes, foreign_key: :season_id
  
  self.primary_key = 'year'
  
  validates :year, {presence: true, uniqueness: true}

end
