class CreateSeasonTable < ActiveRecord::Migration
  def change
    create_table :seasons, {:id => false} do |t|
      t.primary_key       :year

      t.timestamps(null: false)
    end
  end
end
