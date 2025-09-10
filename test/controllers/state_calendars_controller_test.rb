require "test_helper"

class StateCalendarsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @state_calendar = StateCalendar.create!(user: @user, room: @room, mental_state: "🥳", physical_state: "💃", date: "2025-05-01")
    sign_in @user
  end

  test "should get index" do
    get room_state_calendars_url(@room, locale: :ja)
    assert_response :success
  end
end
