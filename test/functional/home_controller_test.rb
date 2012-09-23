require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    #@game = games(:one)

  end

  test "should get index" do
    sign_in :user, users(:one)
    get :index
    assert_response :success
  end

end
