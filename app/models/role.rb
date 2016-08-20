class Role < ActiveRecord::Base

   has_and_belongs_to_many :people

end


def check_role_name
  true
end