require 'test_helper'

class SubsDetailTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  test "get root path unauthenticated" do
    get root_path
    assert_template 'subs/show'
  end

  test "get root path authenticated" do
    log_in_as(users(:one))
    get root_path
    assert_template 'subs/show'
  end

  test "get user path unauthenticated" do
    get user_path(username: users(:one).username)
    assert_template 'users/show'
  end

  test "get user path authenticated" do
    log_in_as(users(:one))
    get user_path(username: users(:one).username)
    assert_template 'users/show'
  end

  test "get post path unauthenticated" do
    get post_comments_path(post_id: post(:one).id)
    assert_template 'users/show'
  end

  test "get post path authenticated" do
    log_in_as(users(:one))
    get post_comments_path(post_id: post(:one).id)
    assert_template 'users/show'
  end
end
