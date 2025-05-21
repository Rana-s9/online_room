require "test_helper"

class ExchangeDiariesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @exchange_diary = ExchangeDiary.create!(user: @user, body: "Hello")
    sign_in @user
  end

  test "should get index" do
    get exchange_diaries_url
    assert_response :success
  end
end
