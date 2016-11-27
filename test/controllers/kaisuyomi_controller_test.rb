require 'test_helper'

class KaisuyomiControllerTest < ActionController::TestCase
  test "should get yomi" do
    get :yomi
    assert_response :success
  end

end
