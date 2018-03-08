require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test "get post path unauthenticated" do
    get post_comments_path(post_id: posts(:one).id)
    assert_response :success
  end

  test "get post path authenticated" do
    log_in_as(users(:one))
    get post_comments_path(post_id: posts(:one).id)
    assert_response :success
  end
end
