require 'test_helper'

class ViewsControllerTest < ActionController::TestCase
  test "should get story" do
    get :story
    assert_response :success
  end

  test "should get movies" do
    get :movies
    assert_response :success
  end

end
