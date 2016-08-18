class TALSeason < ActiveRecord::Base

  has_many :episodes, foreign_key: :season_id, class_name: talepisode:
end
