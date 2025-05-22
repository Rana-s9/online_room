require "test_helper"

class ExchangeDiariesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @exchange_diary = ExchangeDiary.create!(user: @user, room: @room, body: "Hello")
    sign_in @user
  end

  test "should get index" do
    get room_exchange_diaries_url(@room)
    assert_response :success
  end
end
