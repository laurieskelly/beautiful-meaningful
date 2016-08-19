get '/' do 
  @seasons = Season.order(:year)
  erb :"/seasons/index"
end