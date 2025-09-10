require "test_helper"

class AreasControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserFour", email: "test4@example.com", password: "password3")
    @area = Area.create!(user: @user, city: "amsterdam")
    sign_in @user
  end

  test "should get index" do
    get rooms_url(locale: :ja)
    assert_response :success
  end
end
