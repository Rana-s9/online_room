require "test_helper"

class ReadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @exchange_diary = ExchangeDiary.create!(user: @user, room: @room, body: "Hello")
    @read = Read.create!(user: @user, exchange_diary: @exchange_diary)
    sign_in @user
  end

  test "should get index" do
    get room_exchange_diaries_url(@room, locale: :ja)
    assert_response :success
  end
end
