class PersonRole < ActiveRecord::Base

  belongs_to :person
  belongs_to :role
  has_many :chunks, foreign_key: :personrole_id


  def name_
    self.person.name
  end

  def role_
    self.role.title
  end
end