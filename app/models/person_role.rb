class PersonRole < ActiveRecord::Base

  has_many :chunks, foreign_key: :personrole_id

end