require "net/http"
require "uri"
require "json"
class AreasController < ApplicationController
  before_action :set_area, only: [ :update ]

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

    if save_area_weather!(@area)
      redirect_to rooms_path, notice: "地域を登録しました"
    else
      redirect_to areas_path, alert: "天気情報を取得できない都市名です。都市名をご確認ください。"
    end
  end

  def update
    @area.assign_attributes(area_params)
    if save_area_weather!(@area)
      redirect_to rooms_path, notice: "お住まいの地域を更新しました"
    else
      redirect_to root_path, alert: "地域の変更に失敗しました"
    end
  end

  private

  def set_area
    @area = Area.find(params[:id])
  end

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

  def save_area_weather!(area)
    api_data = fetch_weather_from_api(area.city)
    return false unless api_data.present?

    ActiveRecord::Base.transaction do
      area.save!
      weather_record = area.weather_record || area.build_weather_record
      weather_record.update!(
        temperature: api_data["main"]["temp"],
        humidity: api_data["main"]["humidity"],
        description: api_data["weather"][0]["description"],
        temp_min: api_data["main"]["temp_min"],
        temp_max: api_data["main"]["temp_max"]
      )
    end
    true
  rescue => e
    Rails.logger.error "保存エラー: #{e.message}"
    false
  end

  def area_params
    params.require(:area).permit(:city)
  end
end
