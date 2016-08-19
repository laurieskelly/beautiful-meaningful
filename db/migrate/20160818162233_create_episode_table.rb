class CreateEpisodeTable < ActiveRecord::Migration
  def change
    create_table :episodes, {:id => false} do |t|
      t.primary_key     :episode_number
      t.string          :title
      t.string          :archive_url
      t.date            :original_air_date

      t.timestamps(null: false)
    end
  end
end
