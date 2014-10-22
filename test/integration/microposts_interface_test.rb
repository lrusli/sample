require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:lawrence)
	end

	test "micropost interface" do
		log_in_as(@user)
		get root_path
		assert_select '.pagination'
		# Invalid submission.
		post microposts_path, micropost: { content: "" }
		assert_select '.alert-danger'
		# Valid submission.
		content = "A real micropost that works."
		assert_difference 'Micropost.count', 1 do
			post microposts_path, micropost: { content: content }
		end
		follow_redirect!
		assert_match content, response.body
		# Delete a post.
		assert_select 'a', 'delete'
		first_micropost = @user.microposts.paginate(page: 1).first
		assert_difference 'Micropost.count', -1 do
			delete micropost_path(first_micropost)
		end
		# Visit a different user.
		get user_path(users(:larry))
		assert_select 'a', { text: 'delete', count: 0 }
	end
end
