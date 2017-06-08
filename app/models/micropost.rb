class Micropost < ApplicationRecord

  belongs_to :user 							# listing 13.2; 
  											# added by "user:references" in generator

# note use of 'stabby lambda' syntax for defining anonymous function
# -> takes a block, returns a Proc (evaled with a 'call' method)

  default_scope -> { order(created_at: :desc) }		# listing 13.17

  # mount_uploader method used by CarrierWave for image upload
  # listing 13.59
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true 		# listing 13.5
  validates :content, 	presence: true,		# listing 13.8
  						length: { maximum: 140 }

  # use 'validate' (not 'validates') to use custom validation.
  # listing 13.65
  validate :picture_size

  private

  	def picture_size # listing 13.65
  		if picture.size > 5.megabytes
  			errors.add(:picture, "Should be less than 5MB")
  		end
  	end

end
