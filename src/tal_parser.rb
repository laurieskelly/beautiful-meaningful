class SeasonParser

  def initialize(year)
    @year = year
    @datfile = season_filename
    @nk = nokogiri_from_file(@datfile)
  end

  def season_filename
    Dir[DATA_ROOT.join('seasons', "season_#{year}.dat")]
  end

  def nokogiri_from_file(filename)
    html = File.read(filename)
    Nokogiri.parse(html)
  end


end


def nokogiri_from_url(url) 
  Nokogiri.parse(open(url).read)
end