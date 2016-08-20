class Act < ActiveRecord::Base

  belongs_to :episode
  has_many :chunks

  has_many :speakers, -> { distinct }, through: :chunks

end
