require 'test_helper'

class KotobakensakuControllerTest < ActionController::TestCase
  test "should get kekka" do
    get :kekka
    assert_response :success
  end

end
