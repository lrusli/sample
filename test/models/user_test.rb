require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "example", email: "user@example.com",
										 password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = ""
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = ""
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
 		valid_addresses.each do |valid_address|
 			@user.email = valid_address
 			assert @user.valid?
 		end                        
 	end

 	test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@example..com]
 		invalid_addresses.each do |invalid_address|
 			@user.email = invalid_address
 			assert_not @user.valid?
 		end
 	end			                          

 	test "email addresses should be unique" do
 		duplicate_user = @user.dup
 		duplicate_user.email = @user.email.upcase
 		@user.save
 		assert_not duplicate_user.valid?
 	end

 	test "email addresses should be saved as lower-case" do
 		mixed_case_email = "aBC@eXamPLe.cOM"
 		@user.email = mixed_case_email
 		@user.save
 		assert_equal mixed_case_email.downcase, @user.reload.email
 	end

 	test "password should have a minimal length" do
 		@user.password = @user.password_confirmation = "a" * 5
 		assert_not @user.valid?
 	end

 	test "associated microposts should be destroyed" do
 		@user.save
 		@user.microposts.create!(content: "Lorem ipsum")
 		assert_difference 'Micropost.count', -1 do
 			@user.destroy
 		end
 	end

 	test "should follow and unfollow a user" do
 		lawrence = users(:lawrence)
 		isaac 	 = users(:isaac)
 		assert_not lawrence.following?(isaac)
 		lawrence.follow(isaac)
 		assert lawrence.following?(isaac)
 		assert isaac.followers.include?(lawrence)
 		lawrence.unfollow(isaac)
 		assert_not lawrence.following?(isaac)
 	end

 	test "feed should have the right posts" do
 		lawrence = users(:lawrence)
 		larry    = users(:larry)
 		isaac		 = users(:isaac)
 		# Posts from followed user.
 		larry.microposts.each do |post_following|
 			assert lawrence.feed.include?(post_following)
 		end
 		# Posts from self.
 		lawrence.microposts.each do |post_self|
 			assert lawrence.feed.include?(post_self)
 		end
 		# Posts from unfollowed user.
 		isaac.microposts.each do |post_unfollowed|
 			assert_not lawrence.feed.include?(post_unfollowed)
 		end
 	end
end
