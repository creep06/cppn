require 'test_helper'

class RecentProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get recent_problems_create_url
    assert_response :success
  end

  test "should get destroy" do
    get recent_problems_destroy_url
    assert_response :success
  end

end
