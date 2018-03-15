require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  test "logging in view not authenticated" do
    get login_path
    assert_response :success
  end

  test "logging in view authenticated" do
    log_in_as(users(:one))
    get login_path
    assert_response :redirect
  end

  test "logging in view not existing" do
    post login_path, params: {session: {email: 'nonexistent@test.com', password: 'te'}}
    assert_response :success  # rerenders the page
  end

  test "logging in view existing" do
    post login_path, params: {session: {email: users(:one).email, password: 'testtest'}}
    assert_response :redirect
  end

  test "logging in banned" do
    post login_path, params: {session: {email: users(:ban_login).email, password: 'testtest'}}
    assert_response :forbidden
  end
end
