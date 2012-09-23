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

  #1. Test that when a user registers they don't get a fail screen
  #2. When a user signs in, and if they don't have a game yet, they should be
  # 	prompted to join a game.
  

end
