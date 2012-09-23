require 'test_helper'

class ScansControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

	setup do
		#@game = games(:one)
		sign_in :user, users(:one)
	end
end
