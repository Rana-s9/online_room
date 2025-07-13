require "net/http"
require "uri"
require "json"
class AreasController < ApplicationController
  before_action :set_area, only: [ :update ]
  before_action :authenticate_user!

  def create
    @area = current_user.build_area(area_params)

    if save_area_weather!(@area)
      redirect_to rooms_path, notice: t('flash.area.register')
    else
      redirect_to rooms_path, alert: t('flash.area.failed_register')
    end
  end

  def update
    @area.assign_attributes(area_params)
    if save_area_weather!(@area)
      redirect_to rooms_path, notice: t('flash.area.update')
    else
      redirect_to rooms_path, alert: t('flash.area.failed_update')
    end
  end

  private

  def set_area
    @area = Area.find(params[:id])
  end

  def fetch_weather_from_api(city, lang = I18n.locale)
    api_key = ENV["WEATHER_API"]
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric&lang=#{lang}")
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
    ja_data = fetch_weather_from_api(area.city, 'ja')
    en_data = fetch_weather_from_api(area.city, 'en')
    return false unless ja_data.present?

    ActiveRecord::Base.transaction do
      area.save!
      weather_record = area.weather_record || area.build_weather_record
      weather_record.update!(
        temperature: ja_data["main"]["temp"],
        humidity: ja_data["main"]["humidity"],
        description: ja_data["weather"][0]["description"],
        description_en: en_data["weather"][0]["description"],
        temp_min: ja_data["main"]["temp_min"],
        temp_max: ja_data["main"]["temp_max"]
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
