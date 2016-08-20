class Episode < ActiveRecord::Base

  belongs_to :season
  has_many :acts, foreign_key: :episode_number
  has_many :chunks, through: :acts
  has_many :speakers, -> { distinct }, through: :acts

  self.primary_key = 'episode_number'

  validates :episode_number, {presence: true, uniqueness: true}

end



