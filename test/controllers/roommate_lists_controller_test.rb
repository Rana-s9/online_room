require "test_helper"

class RoommateListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.create!(name: "TestUserThree", email: "test3@example.com", password: "password3")
    @room = Room.create!(user: @user, name: "room")
    @roommate_list = RoommateList.create!(user: @user, room: @room)
    sign_in @user
  end
end
