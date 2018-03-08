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

  test "new user authenticated" do
    log_in_as(users(:one))
    get new_user_path
    assert_response :redirect
  end

  test "new user not authenticated" do
    get new_user_path
    assert_response :success
  end

  test "create user authenticated" do
    log_in_as(users(:one))
    post new_user_path, params: {user: {username: 'random', email: 'random@s.com', password: 'testeest', password_confirmation: 'testeest'}}
    assert_redirected_to root_path
  end

  test "create user not authenticated" do
    post new_user_path, params: {user: {username: 'random', email: 'random@s.com', password: 'testeest', password_confirmation: 'testeest'}}
    assert_redirected_to user_path(username: User.last.username)
  end
end
