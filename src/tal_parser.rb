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

  def nokogiri_from_file(filename)
    html = File.read(filename)
    Nokogiri.parse(html)
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


class TranscriptParser

  $base_url = 'http://www.thisamericanlife.org/radio-archives/episode/'

  def initialize(episode_number)
    @transcript_url = $base_url + episode_number + '/transcript'
    @nk = get_transcript_nokogiri
    @table_data = {}
  end

  def get_transcript_nokogiri
    self.nokogiri_from_url(@transcript_url)
  end

  def nokogiri_from_url(url) 
    Nokogiri.parse(open(url).read)
  end


  # # PARSE NOTES
  # archive url: http://www.thisamericanlife.org/radio-archives/episode/1/new-beginnings
  # transcript url: http://www.thisamericanlife.org/radio-archives/episode/1/transcript
  # 
  # everything is in: 
  # <div id="content"><div class="radio-wrapper" id="radio-episode-1">

  # act
  # <div class="act" id="prologue">

  # two interview chunks
  # <div class="interviewer"><h4>Ira Glass</h4><p begin="00:00:00.17">Joe Franklin?</p></div>
  # <div class="subject"><h4>Joe Franklin</h4><p begin="00:00:00.58">I'm ready.</p></div>

  # two host chunks
  # <div class="host">
  # <p begin="00:00:39.96">Well, one great thing about starting a new show is utter anonymity. 
  #    Nobody really knows what to expect from you. This interviewee did not know us from Adam.</p>
  # <p begin="00:00:54.89">OK, we're what? About a minute. We're one minute five into the new show. 
  #    Right now, it is stretching in front of us, a perfect future yet to be fulfilled. An uncharted little world. 
  #    A little baby coming into the world, no little scars on it or anything.</p>
  # ... </div>

  # credits
  # container: <div class="act" id="credits">
  # host: <div class="host"><h4>Ira Glass</h4>

  # stretch feature
  # [MUSIC - "DESTINATION MOON" BY DINAH WASHINGTON]
  
  


end