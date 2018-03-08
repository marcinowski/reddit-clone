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
end
