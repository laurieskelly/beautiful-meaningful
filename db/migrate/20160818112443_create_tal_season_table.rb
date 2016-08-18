class CreateTalSeasonTable < ActiveRecord::Migration
  def change
    create_table :talseason do |t|
      t.integer     :year
      t.s 
  end
end
