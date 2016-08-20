class Role < ActiveRecord::Base

  has_many :person_roles
  has_many :speakers, through: :person_roles, foreign_key: :role_id

end


def check_role_name
  true
end