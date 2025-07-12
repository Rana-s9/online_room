require "net/http"
require "uri"
require "json"

class WeatherRecordsController < ApplicationController
  before_action :authenticate_user!

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

  def fetch_weather_from_api(city, lang = 'ja')
    api_key = ENV["WEATHER_API"]
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric&lang=#{lang}")
    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      Rails.logger.debug "API (#{lang}) description: #{data['weather'][0]['description']}"
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
    ja_data = fetch_weather_from_api(area.city, 'ja')
    en_data = fetch_weather_from_api(area.city, 'en')

    if ja_data.present? && en_data.present?
      weather_record.assign_attributes(
        temperature: ja_data["main"]["temp"],
        humidity: ja_data["main"]["humidity"],
        description: ja_data["weather"][0]["description"],
        description_en: en_data["weather"][0]["description"],
        temp_min: ja_data["main"]["temp_min"],
        temp_max: ja_data["main"]["temp_max"]
      )

      if weather_record.save
        room = Room.find(params[:room_id])
        redirect_to room_path(room), notice: t('views.weather.update')
      else
        redirect_to areas_path, alert: t('views.weather.failed_save')
      end
    else
      redirect_to root_path, alert: t('views.weather.failed_retrieve')
    end
  end

  def weather_record_params
    params.require(:weather_record).permit(:temperature, :humidity, :description, :description_en, :temp_min, :temp_max)
  end
end
