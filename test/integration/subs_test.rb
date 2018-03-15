require 'test_helper'

class SubsTest < ActionDispatch::IntegrationTest
  test "get root path unauthenticated" do
    get root_path
    assert_response :success
  end

  test "get root path authenticated" do
    log_in_as(users(:one))
    get root_path
    assert_response :success
  end

  test "get sub path not authenticated" do
    get sub_path(slug: subs(:one).slug)
    assert_response :success
  end

  test "get sub path authenticated" do
    log_in_as(users(:one))
    get sub_path(slug: subs(:one).slug)
    assert_response :success
  end

  test "new sub not authenticated" do
    get new_sub_path
    assert_response :unauthorized
  end

  test "new sub authenticated" do
    log_in_as(users(:one))
    get new_sub_path
    assert_response :success
  end

  test "new sub banned" do
    log_in_as(users(:one))
    get new_sub_path
    assert_response :success
  end

  test "create sub not authenticated" do
    assert_no_difference('Sub.count') do
      post subs_path, params: {sub: {slug: 'tessst'}}
    end
  end

  test "create sub authenticated" do
    log_in_as(users(:one))
    assert_difference('Sub.count') do
      post subs_path, params: {sub: {slug: 'tessst'}}
    end
  end

  test "create sub banned" do
    log_in_as(users(:ban))
    assert_no_difference('Sub.count') do
      post subs_path, params: {sub: {slug: 'tessst'}}
    end
  end

  test "get edit sub path not authenticated" do
    get edit_sub_path(slug: subs(:one).slug)
    assert_response :forbidden
  end

  test "get edit sub path not mod" do
    log_in_as(users(:two))
    get edit_sub_path(slug: subs(:one).slug)
    assert_response :forbidden
  end

  test "get edit sub path mod" do
    log_in_as(users(:one))
    get edit_sub_path(slug: subs(:one).slug)
    assert_response :success
  end
end
