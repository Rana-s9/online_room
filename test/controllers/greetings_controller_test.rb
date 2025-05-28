require "test_helper"

class GreetingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @greeting = Greeting.create!(user: @user, room: @room, message: "im home", greeting_type: 1)
    sign_in @user
  end

  test "should get index" do
    get room_greetings_url(@room)
    assert_response :success
  end
end
