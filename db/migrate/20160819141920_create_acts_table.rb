class CreateActsTable < ActiveRecord::Migration
  def change
    create_table :acts do |t|
      t.string    :name
      t.integer   :episode_number

      t.timestamps(null: false)
    end
  end
end
