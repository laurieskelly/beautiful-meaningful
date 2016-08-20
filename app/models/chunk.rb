class Chunk < ActiveRecord::Base

  belongs_to :act
  has_one :episode, through: :act, foreign_key: :episode_number

  has_one :personrole
  

end
