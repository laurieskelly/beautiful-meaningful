class PersonRole < ActiveRecord::Base

  belongs_to :speaker, class_name: :Person, foreign_key: :person_id
  belongs_to :role
  has_many :chunks, foreign_key: :personrole_id


  def name_
    self.speaker.name
  end

  def role_
    self.role.title
  end
end