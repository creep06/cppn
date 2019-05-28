require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get problems_create_url
    assert_response :success
  end

  test "should get destroy" do
    get problems_destroy_url
    assert_response :success
  end

end
