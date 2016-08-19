require APP_ROOT.join('src','tal_parser.rb')

fails = []

1995.upto(2016) do |year|

  parser=SeasonParser.new(year)

  Season.create({year: year, datfile: parser.datfile})

  parser.episode_divs.each do |seed|

    ep_parser = EpisodeParser.new(seed)
    episode = Episode.new(ep_parser.table_data)

    if episode.valid? 
      episode.save 
    else
      fails << {
        year: year, 
        episode: ep_parser.episode_number, 
        fails: episode.errors.full_messages
      }
    end

  end
end

require 'json'

JSON.dump(fails, open(APP_ROOT.join('db','failfile.json'),'w'))
