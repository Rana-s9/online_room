require "net/http"
require "uri"
require "json"
class AreasController < ApplicationController
  def index
    api_key = ENV["WEATHER_API"]
    city = "madagascar"
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric&lang=ja")

    response = Net::HTTP.get_response(url)
    weather_data = JSON.parse(response.body)

    Rails.logger.debug(weather_data)

    @weather_data = weather_data
  end

  def create
    @area = current_user.build_area(area_params)
    if @area.save
        redirect_to rooms_path, notice: "お住まいの地域を登録しました"
    else
        redirect_to root_path, alert: "地域の登録に失敗しました"
    end
  end

  def update
    @area = Area.find(params[:id])

    if @area.update(area_params)
      redirect_to rooms_path, notice: "お住まいの地域を更新しました"
    else
      redirect_to root_path, alert: "地域の変更に失敗しました"
    end
  end


  def area_params
    params.require(:area).permit(:city)
  end
end
