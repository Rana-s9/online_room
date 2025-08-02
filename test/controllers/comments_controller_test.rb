require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserFour", email: "test4@example.com", password: "password3")
    @room = Room.create!(name: "Test Room", user: @user)
    @spot = Spot.create!(user: @user, room: @room, name: "高良山", visit_status: 1, address: "高良山", latitude: 33.2974086, longitude: 130.5742861)
    @comment = Comment.create!(user: @user, spot: @spot, body: "comments")

    sign_in @user
  end

  test "should get index" do
    get room_spot_url(@spot.room, @spot, locale: :ja)
    assert_response :success
  end
end
