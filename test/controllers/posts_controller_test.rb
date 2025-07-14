require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserFour", email: "test4@example.com", password: "password3")
    @post = Post.create!(user: @user, relationship: 0, post_type: 0, situation: 0, content: "test", display_name: 0)
    sign_in @user
  end

  test "should get index" do
    get posts_url(locale: :ja)
    assert_response :success
  end
end
