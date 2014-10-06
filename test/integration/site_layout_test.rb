require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

	def setup
		@base_title = "RoR Tutorial"
		@user = users(:lawrence)
	end

	test "layout links as logged out and logged in users" do
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path
		assert_select "a[href=?]", help_path 
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path
		assert_select "a[href=?]", logout_path, count: 0
		log_in_as(@user)
		get root_path
		assert_select "a[href=?]", logout_path
	end

	test "signup page" do
		get signup_path
		assert_select "h1", "Sign up"
	end
end
