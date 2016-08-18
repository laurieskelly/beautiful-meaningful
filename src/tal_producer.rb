require 'nokogiri'



def nokogiri_from_file(filename)
  html = File.read(filename)
  Nokogiri.parse(html)
end

def nokogiri_from_url(url) 
  Nokogiri.parse(open(url).read)
end