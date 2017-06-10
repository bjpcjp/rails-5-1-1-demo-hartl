class User < ApplicationRecord

  #has_many :microposts                           # listing 13.11
  has_many :microposts, dependent: :destroy       # listing 13.19

                                                  # listing 14.2
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

                                                # listing 14.12
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

                                                  # listing 14.8
                                                  # listing 14.12
  has_many :following, through: :active_relationships, source: :followed 
  has_many :followers, through: :passive_relationships, source: :follower


	attr_accessor :remember_token 					        # listing 9.3
  attr_accessor :activation_token                 # listing 11.3
  attr_accessor :reset_token                      # listing 12.6

  before_save   :downcase_email                   # listing 6.32
  before_create :create_activation_digest         # listing 11.3

	validates :name, 								                # listing 6.9
		presence: true,
		length: { maximum: 50 } 					            # listing 6.16
	
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, 								              # listing 6.12
		presence: true ,
		length: { maximum: 50 }, 				              # listing 6.16
		format: { with: VALID_EMAIL_REGEX }, 		      # listing 6.21
		uniqueness: { case_sensitive: false } 		    # listing 6.25, 6.27

	has_secure_password

  	validates :password, 							            # listing 6.42
  		presence: true, 
  		length: { minimum: 6 },
=begin 
we need an exception to password validation if password=empty. 
We can do this by passing the allow_nil: true option to validates.
=end
  		allow_nil: true								# listing 10.13

  # return hash digest of given string.
  # listing 8.21
  def User.digest(str)
  	cost = ActiveModel::SecurePassword.min_cost ? 
  	BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  	BCrypt::Password.create(str, cost: cost)
  end

  # return new random token
  # listing 9.2
  def User.new_token
  	SecureRandom.urlsafe_base64
  end

  # We need User.remember_token	to be available (for cookie storage)
  # without storing it in the DB.
  # Use 'update_attribute' to bypass validation checks.

  # listing 9.3
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  # listing 11.26
  # does account activation digest match the given token?
  # demos METAPROGRAMMING via 'send' method
  # "#{attribute}_digest" becomes "activation_digest"

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # forget a user
  # listing 9.11
  def forget
  	update_attribute(:remember_digest, nil)
  end

  # listing 11.35 - refactoring
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest # listing 12.6
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email # listing 12.6
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired? # listing 12.17
    reset_sent_at < 2.hours.ago
  end

=begin 

# listing 13.46 ("user_id = ?" ensures id is escaped before SQL query,
avoids SQL injection risk)

# listing 14.44 (how is this query built?)

>> [1, 2, 3, 4].map { |i| i.to_s }     => ["1", "2", "3", "4"]
>> [1, 2, 3, 4].map(&:to_s)            => ["1", "2", "3", "4"] (Ruby idiom)
>> [1, 2, 3, 4].map(&:to_s).join(', ') => "1, 2, 3, 4"
>> User.first.following.map(&:id)      => [3, 4,...,50, 51] (list of "following")
>> User.first.following_ids            => [3, 4,...,50, 51] (Rails idiom)
>> User.first.following_ids.join(', ') => "3, 4,...,50, 51"

* Rails "?" interpolation does this for you!
Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)

* listing 14.46, 14.47 (SQL subselect optimization)
* replace 'following_ids' with an SQL subselect:
  following_ids = "SELECT followed_id FROM relationships
                 WHERE  follower_id = :user_id"
* now using raw SQL, so 'following_ids' is interpolated - not escaped.

=end

  def feed # defines proto-feed -- listing 13.46, 14.44, 14.46
    #Micropost.where("user_id = ?", id)
    #Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    #Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                following_ids: following_ids, user_id: id)

    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"

    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    
  end

  # listing 14.10 - Follows a user.
  def follow(other_user)
    following << other_user
  end

  # listing 14.10 - Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # listing 14.10 - current user following other user?
  def following?(other_user)
    following.include?(other_user)
  end

  private

    # listing 11.3
    def downcase_email
      self.email = email.downcase
    end

    # listing 11.3
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end	
