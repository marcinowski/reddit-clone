require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest
  test "get user path unauthenticated" do
    get user_path(username: users(:one).username)
    assert_response :success
  end

  test "get user path authenticated" do
    log_in_as(users(:one))
    get user_path(username: users(:one).username)
    assert_response :success
  end
end
