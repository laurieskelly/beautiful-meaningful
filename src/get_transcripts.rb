
fails = []
to_get = [4,5,6,7]

to_get.each do |ep|
  puts "getting #{ep}"

  tg = TranscriptGetter.new(ep)

  begin
    tg.save_html
  rescue
    fails << ep
  else
    fails << ep unless tg.saved?
  end

end

failfile = File.open(APP_ROOT.join('data','transcript_fails.dat'),mode='w')
failfile.write(fails)
