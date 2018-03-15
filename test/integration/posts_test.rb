require 'test_helper'

class PostsTest < ActionDispatch::IntegrationTest
  test "get add post path authenticated" do
    log_in_as(users(:one))
    get new_sub_post_path(sub_slug: subs(:one).slug)
    assert_response :success
  end

  test "get add post path not authenticated" do
    get new_sub_post_path(sub_slug: subs(:one).slug)
    assert_response 401
  end

  test "get add post path banned" do
    log_in_as(users(:ban))
    get new_sub_post_path(sub_slug: subs(:one).slug)
    assert_response 403
  end

  test "get add post path banned on sub" do
    log_in_as(users(:ban_sub))
    get new_sub_post_path(sub_slug: subs(:one).slug)
    assert_response 403
  end

  test "post create post authenticated" do
    log_in_as(users(:one))
    assert_difference('Post.count') do
      post posts_path, params: {post: {sub_id: subs(:one).id, title: 'Test', description: 'test'}}
    end
  end

  test "post create post not authenticated" do
    assert_no_difference('Post.count') do
      post posts_path, params: {post: {sub_id: subs(:one).id, title: 'Test', description: 'test'}}
    end
  end

  test "post create post banned" do
    log_in_as(users(:ban))
    assert_no_difference('Post.count') do
      post posts_path, params: {post: {sub_id: subs(:one).id, title: 'Test', description: 'test'}}
    end
  end

  test "post create post banned on sub" do
    log_in_as(users(:ban_sub))
    assert_no_difference('Post.count') do
      post posts_path, params: {post: {sub_id: subs(:one).id, title: 'Test', description: 'test'}}
    end
  end

  test "post edit post path not authenticated" do
    get edit_post_path(id: posts(:one).id)
    assert_response 401
  end

  test "post edit post path not owner" do
    log_in_as(users(:two))
    get edit_post_path(id: posts(:one).id)
    assert_response 403
  end

  test "post edit post path owner" do
    log_in_as(users(:one))
    get edit_post_path(posts(:one))
    assert_response :success
  end

  test "put update post path not authenticated" do
    put post_path(posts(:one))
    assert_response 401
  end

  test "put update post path not owner" do
    log_in_as(users(:two))
    put post_path(posts(:one))
    assert_response 403
  end

  test "put update post path owner" do
    log_in_as(users(:one))
    put post_path(posts(:one)), params: {post: {title: 'Test changed'}}
    assert_response :redirect
  end

  test "delete post path not authenticated" do
    assert_no_difference('Post.count') do
      delete post_path(id: posts(:one).id)
    end
  end

  test "delete post path not owner" do
    log_in_as(users(:two))
    assert_no_difference('Post.count') do
      delete post_path(id: posts(:one).id)
    end
  end

  test "delete post path owner" do
    log_in_as(users(:one))
    assert_difference('Post.count', -1) do
      delete post_path(id: posts(:one).id)
    end
  end
end
