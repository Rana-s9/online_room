require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url(locale: :ja)
    assert_response :success
  end
end
