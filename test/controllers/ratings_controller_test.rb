require 'test_helper'

class RatingsControllerTest < ActionDispatch::IntegrationTest
  test "should get vote" do
    get ratings_vote_url
    assert_response :success
  end

end
