class Chunk < ActiveRecord::Base

  belongs_to :act
  has_one :episode, through: :act, foreign_key: :episode_number
  belongs_to :person_role, foreign_key: :personrole_id

  has_one :speaker, through: :person_role, source: :speaker
  has_one :speaker_role, through: :person_role, source: :role
  

end
