require "test_helper"

class WeatherRecordsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserFour", email: "test4@example.com", password: "password3")
    @area = Area.create!(user: @user, city: "amsterdam")
    @weather_record = WeatherRecord.create!(temperature: 18, humidity: 50, description: "曇りがち", temp_min: 14, temp_max: 20, area: @area)
    sign_in @user
  end
end
