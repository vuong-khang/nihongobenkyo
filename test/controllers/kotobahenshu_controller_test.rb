require 'test_helper'

class KotobahenshuControllerTest < ActionController::TestCase
  test "should get shusei" do
    get :shusei
    assert_response :success
  end

end
