class CreateChunksTable < ActiveRecord::Migration
  def change
    create_table :chunks do |t|
      t.string    :start
      t.integer   :personrole_id
      t.integer   :act_id
      t.string    :text
      t.integer   :numwords

      t.timestamps(null: false)
    end
  end
end
