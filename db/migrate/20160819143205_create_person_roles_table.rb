class CreatePersonRolesTable < ActiveRecord::Migration
  def change
    create_table :person_roles do |t|
      t.integer     :person_id
      t.integer     :role_id
    end
  end
end
