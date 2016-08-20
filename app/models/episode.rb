class Episode < ActiveRecord::Base

  belongs_to :season
  has_many :acts
  has_many :chunks, through: :acts

  self.primary_key = 'episode_number'

  validates :episode_number, {presence: true, uniqueness: true}

end



