require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: "",
															 email: "invalid@user.com",
															 password:  						"foobar",
															 password_confirmation: "barfoo" }
		end
		assert_template 'users/new'
		assert_select '.field_with_errors'
	end

	test "valid signup information" do
		get signup_path
		name		 = "example"
		email		 = "example@user.com"
		password = "password"
		assert_difference 'User.count', 1 do
			# Follows the redirect path after submission.
			post_via_redirect users_path, user: { name: name,
																						email: email,
																						password: 						 password,
																						password_confirmation: password }
		end
		assert_template 'users/show'
		assert_not flash.empty?
		assert is_logged_in?
	end
end
