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

# require 'json'

# JSON.dump(fails, open(APP_ROOT.join('db','failfile.json'),'w'))
no_transcript = []

Episode.all.each do |episode|
  epid = episode.episode_number
  begin
    parser=TranscriptParser.new(epid)
  rescue
    no_transcript << epid
    next
  end

  parser.acts.each do |act|
    tableact = Act.create({episode_number: epid, name: act.name})

    if tableact
      act.speakers.each do |person, role|
        tableperson = Person.find_or_create_by({name: person})
        tablerole = Role.find_or_create_by({role: role})
        personrole = PersonRole.find_or_create_by({person_id:tableperson.id, role_id:tablerole.id})
      end

      act.chunks.each do |chunk|
        chunkdata = chunk.data
        chunkperson = Person.find_by(name: chunkdata[:person])
        chunkrole = Role.find_by(role: chunkdata[:role])
        chunkpersonrole = PersonRole.find_by({
          person_id: chunkperson,
          role_id: chunkrole
        })

        tablechunk = Chunk.create({
          start: chunkdata[:start],
          personrole_id: chunkpersonrole.id,
          act_id: tableact.id,
          text: chunkdata[:text],
          numwords: chunkdata[:numwords]
        })
      end
    end
  end
end

puts no_transcript