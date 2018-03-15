require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test "get comment path unauthenticated" do
    get post_comments_path(post_id: posts(:one).id)
    assert_response :success
  end

  test "get comment path authenticated" do
    log_in_as(users(:one))
    get post_comments_path(post_id: posts(:one).id)
    assert_response :success
  end

  test "post comment create not authenticated" do
    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: posts(:one).id), params: {comment: {content: 'test'}}
    end
  end

  test "post comment create authenticated" do
    log_in_as(users(:one))
    assert_difference('Comment.count') do
      post post_comments_path(post_id: posts(:one).id), params: {comment: {content: 'test'}}
    end
  end

  test "post comment create banned" do
    log_in_as(users(:ban))
    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: posts(:one).id), params: {comment: {content: 'test'}}
    end
  end

  test "post comment create banned on sub" do
    log_in_as(users(:ban_sub))
    assert_no_difference('Comment.count') do
      post post_comments_path(post_id: posts(:one).id), params: {comment: {content: 'test'}}
    end
  end

  test "put update comment not authenticated" do
    put post_comment_path(post_id: posts(:one).id, id: comments(:one).id)
    assert_response 401
  end

  test "put update comment not owner" do
    log_in_as(users(:two))
    put post_comment_path(post_id: posts(:one).id, id: comments(:one).id)
    assert_response 403
  end

  test "put update comment owner" do
    log_in_as(users(:one))
    put post_comment_path(post_id: posts(:one).id, id: comments(:one).id), params: {comment: {content: 'Test changed'}}
    assert_response :redirect
  end

  test "delete comment not authenticated" do
    assert_no_difference('Comment.count') do
      delete post_comment_path(post_id: posts(:one).id, id: comments(:one).id)
    end
  end

  test "delete comment not owner" do
    log_in_as(users(:two))
    assert_no_difference('Comment.count') do
      delete post_comment_path(post_id: posts(:one).id, id: comments(:one).id)
    end
  end

  test "delete comment owner" do
    log_in_as(users(:one))
    assert_difference('Comment.count', -1) do
      delete post_comment_path(post_id: posts(:one).id, id: comments(:one).id)
    end
  end
end
