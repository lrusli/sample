require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do
		assert_equal full_title, "RoR Tutorial"
		assert_equal full_title("help"), "help | RoR Tutorial"
	end
end