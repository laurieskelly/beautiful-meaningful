require 'nokogiri'



# get html from a file
def nokogiri_from_file(filename)
  html = File.read(filename)
  clean_html = HTMLWhitespaceCleaner.clean(html)
  Nokogiri.parse(clean_html)
end


def nokogiri_from_url(url) 
  Nokogiri.parse(HTMLWhitespaceCleaner.clean(open(url).read))
end