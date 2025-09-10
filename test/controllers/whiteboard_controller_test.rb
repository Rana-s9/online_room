require "test_helper"

class WhiteboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @whiteboard = Whiteboard.create!(user: @user, room: @room, body: "message")
    sign_in @user
  end

  test "should get index" do
    get room_url(@room, locale: :ja)
    assert_response :success
  end
end
