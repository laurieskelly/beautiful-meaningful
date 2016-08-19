get "/seasons" do

  @seasons = Season.order(:year)
  erb :"/seasons/index"
end

get "/seasons/:id" do

  @season = Season.find(params[:id])
  erb :"/seasons/show"
  
end