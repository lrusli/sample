require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

	def setup
		@base_title = "RoR Tutorial"
	end

	test "layout links" do
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path
		assert_select "a[href=?]", help_path 
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path
	end

	test "signup page" do
		get signup_path
		assert_select "h1", "Sign up"
	end
end
