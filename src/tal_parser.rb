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

  def nokogiri_from_url(url) 
    Nokogiri.parse(open(url).read)
  end

end