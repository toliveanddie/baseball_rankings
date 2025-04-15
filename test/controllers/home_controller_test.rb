require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get overall" do
    get home_overall_url
    assert_response :success
  end

  test "should get batting" do
    get home_batting_url
    assert_response :success
  end

  test "should get pitching" do
    get home_pitching_url
    assert_response :success
  end

  test "should get weekly" do
    get home_weekly_url
    assert_response :success
  end
end
