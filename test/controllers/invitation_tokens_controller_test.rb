require "test_helper"

class InvitationTokensControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @invitation_token = InvitationToken.create!(user: @user, room: @room, token: "unique_token_#{SecureRandom.hex(16)}", expires_at: "2025-05-30 15:06:38.333302000 +0000")
    sign_in @user
  end

  test "should get index" do
    get room_invitation_tokens_url(@room, locale: :ja)
    assert_response :success
  end
end
