require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "home | RoR Tutorial"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "help | RoR Tutorial"
  end

  test "should get about" do
  	get :about
  	assert_response :success
  	assert_select "title", "about | RoR Tutorial"
  end
end
