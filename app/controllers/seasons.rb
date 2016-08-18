get "/seasons" do

  @seasons = Season.all
  erb :"/seasons/index"
end