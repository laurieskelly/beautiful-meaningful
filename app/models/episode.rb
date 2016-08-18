class Episode < ActiveRecord::Base

  belongs_to :season, primary_key: :year

end
