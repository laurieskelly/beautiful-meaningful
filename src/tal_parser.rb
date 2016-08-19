require 'open-uri'

$transcript_dir = DATA_ROOT.join('transcripts')
$base_url = 'http://www.thisamericanlife.org/radio-archives/episode/'

def nokogiri_from_file(filename)
  html = File.read(filename)
  Nokogiri.parse(html)
end

def transcript_filename(episode_number)
  $transcript_dir.join("episode_#{episode_number}_transcript.htm")
end

class SeasonParser

  attr_reader :datfile
  def initialize(year)
    @year = year
    @datfile = season_filename
    @nk = nokogiri_from_file(@datfile)
  end

  def season_filename
    DATA_ROOT.join('seasons', "season_#{@year}.dat")
  end

  
  def episode_divs 
    @nk.css('div.episode-archive')
  end

end


class EpisodeParser

  attr_reader :table_data
  def initialize(seed_div)
    @nk = seed_div
    @table_data = {
      title: self.title,
      archive_url: self.archive_url,
      original_air_date: self.air_date,
      episode_number: self.episode_number,
      season_id: self.year
    }
  end  

  def archive_url 
    @nk.css('a.image').first.attr('href')
  end

  def air_date_string
    @nk.css('h3').first.css('span').first.text
  end

  def air_date
    convert_date(self.air_date_string)
  end

  def header_string
    @nk.css('h3').first.css('a').first.text
  end

  def episode_number
    self.header_string.split(':')[0].to_i
  end
  
  def title
    self.header_string.split(':')[1].remove(self.air_date_string).strip
  end

  def year 
    self.air_date.split('-')[0].to_i
  end

  private 
  
  # turns '07.25.2016' into '2016-07-25'
  def convert_date(datestr)
    components = datestr.split('.')
    components.unshift(components.pop).join('-')
  end

end


class TranscriptGetter

  def initialize(episode_number)
    @transcript_url = "#{$base_url}#{episode_number}/transcript"
    @transcript_filename = transcript_filename(episode_number)
  end

  def saved?
    self.save_html > 0
  end

  def html_from_url 
    OpenURI.open_uri(@transcript_url).read
  end

  def transcript_file_obj
    File.open(@transcript_filename, mode='w')
  end

  def save_html
    transcript_file_obj.write(html_from_url)
  end

end

class TranscriptParser

  attr_reader :episode_data, :nk
  def initialize(episode_number)
    @id = episode_number
    @nk = transcript_nokogiri
    @episode_data = {
      host: episode_host,
      acts: acts
    }
   
  end

  def transcript_nokogiri
    nokogiri_from_file(transcript_filename(@id)).css('div#content>div.radio-wrapper')
  end
  
  # # PARSE NOTES
  # archive url: http://www.thisamericanlife.org/radio-archives/episode/1/new-beginnings
  # transcript url: http://www.thisamericanlife.org/radio-archives/episode/1/transcript
  # 
  # everything is in: 
  # <div id="content"><div class="radio-wrapper" id="radio-episode-1">

  # MVP
  # episode host (credits)
  # container: <div class="act" id="credits">
  # host: <div class="host"><h4>Ira Glass</h4>
  def episode_host 
    @nk.css('div.act#credits div.host>h4').text
  end

  # act
  # <div class="act" id="prologue">
  def act_names
    all_names = @nk.css('div.act').map {|act| act.attr('id')}
    all_names.to_a.select {|name| name != 'credits'}
  end

  def acts
    self.act_names.map {|name| ActData.new(act_nk(name), name)}
  end

  private
  def act_nk(act_name)
    @nk.css(".act#"+act_name)
  end


end
  
  # interview chunk
  # <div class="interviewer"><h4>Ira Glass</h4><p begin="00:00:00.17">Joe Franklin?</p></div>

  # two host chunks
  # <div class="host">
  # <p begin="00:00:39.96">Well, one great thing about starting a new show is utter anonymity. 
  #    Nobody really knows what to expect from you. This interviewee did not know us from Adam.</p>
  # <p begin="00:00:54.89">OK, we're what? About a minute. We're one minute five into the new show. 
  #    Right now, it is stretching in front of us, a perfect future yet to be fulfilled. An uncharted little world. 
  #    A little baby coming into the world, no little scars on it or anything.</p>
  # ... </div>


  # STRETCH
  # <div class="subject"><h4>Joe Franklin</h4><p begin="00:00:00.58">I'm ready.</p></div>



  # stretch feature
  # [MUSIC - "DESTINATION MOON" BY DINAH WASHINGTON]



class ActData
  attr_reader :nk, :speakers, :chunks, :name
  def initialize(act_nk, name)
    @nk = act_nk
    @name = name
    @speakers = speakers # [[<name>, <role>],[<name>,<role>]]
    @chunks = chunks

  end

  def superchunk_nks
    @nk.css('div.act-inner>div')
  end

  def speakers
    names = @nk.css('h4').map {|h| h.text}
    roles = superchunk_nks.map {|d| d.attr('class')}
    names.zip(roles)
  end

  def chunks
    chunkarray = []
    @speakers.each_with_index do |speaker, index|
      superchunk_nks[index].css('p').each do |p|
        chunkarray << ChunkData.new(p, speaker)
      end
    end
    chunkarray
  end

end

class ChunkData

  attr_reader :data
  def initialize(chunk_nk, speaker)
    @nk = chunk_nk
    @data = {
      person: speaker[0],
      role: speaker[1],
      text: chunk_text,
      start: timestamp,
      end: nil,
      numwords: chunk_text.length
    }
  end

  def chunk_text
    @nk.text
  end

  def timestamp
    @nk.attr('begin')
  end

end