require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @calendar = Calendar.create!(user: @user, room: @room, name: "a", description: "a", start_time: "2025-07-24T14:19", end_time: "2025-07-24T14:49", schedule_type: 0, visibility: 0, source: 0, category: 0)
    sign_in @user
  end

  test "should get index" do
    get room_calendars_url(@room, locale: :ja)
    assert_response :success
  end
end
