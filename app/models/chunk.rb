class Chunk < ActiveRecord::Base

  belongs_to :act
  has_one :episode, through: :act, foreign_key: :episode_number

  belongs_to :speaker, class_name: :PersonRole,
                       foreign_key: :personrole_id
  

end
