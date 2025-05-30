require "test_helper"

class SpotsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @Spot  = Spot.create!(user: @user, room: @room, name: "高良山", visit_status: 1, address: "高良山", latitude: 33.2974086, longitude: 130.5742861)
    sign_in @user
  end

  test "should get index" do
    get room_spots_url(@room)
    assert_response :success
  end
end
