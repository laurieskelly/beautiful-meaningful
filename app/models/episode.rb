class Episode < ActiveRecord::Base

  belongs_to :season

  self.primary_key = 'episode_number'

  validates :episode_number, {presence: true, uniqueness: true}

end



