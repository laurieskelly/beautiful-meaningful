class Person < ActiveRecord::Base

  has_many :person_roles
  has_many :roles, through: :person_roles
  has_many :chunks, through: :person_roles

end
