class Act < ActiveRecord::Base

  belongs_to :episode, foreign_key: :episode_number
  has_many :chunks

  has_many :speakers, -> { distinct }, through: :chunks

end
