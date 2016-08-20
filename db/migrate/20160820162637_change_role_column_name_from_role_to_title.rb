class ChangeRoleColumnNameFromRoleToTitle < ActiveRecord::Migration
  def change
    rename_column :roles, :role, :title
  end
end
