require "net/http"
require "uri"
require "json"
class WeatherRecordsController < ApplicationController
  def create
    area = Area.find(params[:area_id])
    @weather_record = WeatherRecord.new(area_id: area.id)
    save_weather_record(area, @weather_record)
  end

  def update
    area = Area.find(params[:area_id])
    @weather_record = WeatherRecord.find_by(area_id: area.id)
    save_weather_record(area, @weather_record)
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

  def save_weather_record(area, weather_record)
    api_data = fetch_weather_from_api(area.city)
    Rails.logger.debug "取得した天気データ: #{api_data}"

    if api_data
        weather_record.assign_attributes(
        temperature: api_data["main"]["temp"],
        humidity: api_data["main"]["humidity"],
        description: api_data["weather"][0]["description"],
        temp_min: api_data["main"]["temp_min"],
        temp_max: api_data["main"]["temp_max"]
        )

        if weather_record.save
        room = Room.find(params[:room_id])
        redirect_to room_path(room), notice: "天気情報を更新しました"
        else
        redirect_to areas_path, alert: "天気情報の保存に失敗しました"
        end
    else
        redirect_to root_path, alert: "天気情報を取得できませんでした。"
    end
  end

  def weather_record_params
    params.require(:weather_record).permit(:temperature, :humidity, :description, :temp_min, :temp_max)
  end
end
