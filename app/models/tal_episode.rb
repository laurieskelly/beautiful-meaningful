class TALEpisode < ActiveRecord::Base

  belongs_to :season, class_name: :talseason

end
