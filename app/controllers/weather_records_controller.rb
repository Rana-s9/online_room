require "net/http"
require "uri"
require "json"
class WeatherRecordsController < ApplicationController
  def create
    city = params[:city]
    Rails.logger.debug "送信された city パラメータ: #{city}"

    area = Area.find(params[:area_id])
    Rails.logger.debug "見つかった Area: #{area.inspect}"

    api_data = fetch_weather_from_api(area.city)
    Rails.logger.debug "取得した天気データ: #{api_data}"

    if area
      if api_data
        @weather_record = WeatherRecord.new(
            area_id: area.id,
            temperature: api_data["main"]["temp"],
            humidity: api_data["main"]["humidity"],
            description: api_data["weather"][0]["description"],
            temp_min: api_data["main"]["temp_min"],
            temp_max: api_data["main"]["temp_max"]
        )
        if @weather_record.save
            redirect_to rooms_path, notice: "天気情報を更新しました"
        else
            redirect_to areas_path, alert: "天気情報の保存に失敗しました"
        end
      else
        redirect_to root_path, alert: "天気情報を取得できませんでした。"
      end
    else
        redirect_to root_path, alert: "お住まいの地域が登録されていません。"
    end
  end

  private

  def fetch_weather_from_api(city)
    api_key = ENV["WEATHER_API"]
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric&lang=ja")
    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        Rails.logger.debug "API description: #{data['weather'][0]['description']}"
        data
    else
        Rails.logger.error "API request failed: #{response.code} #{response.message}"
        nil
    end
  rescue => e
    Rails.logger.error "Weather API error: #{e.message}"
    nil
  end

  def weather_record_params
    params.require(:weather_record).permit(:temperature, :humidity, :description, :temp_min, :temp_max)
  end
end
