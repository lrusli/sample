class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  class << self
    # Returns users followed by the given user.
    def from_users_followed_by(user)
      # Inefficient because it takes all user ids into the array.
      # following_ids = user.following_ids
      # where("user_id IN (?) OR user_id = ?", following_ids, user)

      # With subselects performed in SQL, it's more efficient.
      following_ids = "SELECT followed_id FROM relationships
                       WHERE  follower_id = :user_id"
      where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user)
    end
  end

  # Alternative declaration for class method.
  # def Micropost.from_users_followed_by(user)

  private

  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
end
