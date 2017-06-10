class Relationship < ApplicationRecord

	belongs_to :follower, 	class_name: "User"		# listing 14.3
	belongs_to :followed,	class_name: "User"

	validates :follower_id, presence: true			# listing 14.5
    validates :followed_id, presence: true

end
