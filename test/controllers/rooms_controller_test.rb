require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserFour", email: "test4@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    sign_in @user
  end

  test "should get index" do
    get rooms_url
    assert_response :success
  end
end
