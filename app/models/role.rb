class Role < ActiveRecord::Base

  before_save: :check_role_name

  has_and_belongs_to_many :people

end


def check_role_name
  true
end