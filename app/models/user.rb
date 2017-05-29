class User < ApplicationRecord

	attr_accessor :remember_token 					# listing 9.3

	validates :name, 								# listing 6.9
		presence: true,
		length: { maximum: 50 } 					# listing 6.16
	

  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  	before_save { self.email = email.downcase } 	# listing 6.32

	validates :email, 								# listing 6.12
		presence: true ,
		length: { maximum: 50 }, 					# listing 6.16
		format: { with: VALID_EMAIL_REGEX }, 		# listing 6.21
		uniqueness: { case_sensitive: false } 		# listing 6.25, 6.27

	has_secure_password

  	validates :password, 							# listing 6.42
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

=begin
We need User.remember_token	to be available (for cookie storage)
without storing it in the DB.
Use 'update_attribute' to bypass validation checks.
=end

  	# listing 9.3
  	def remember
  		self.remember_token = User.new_token
  		update_attribute(:remember_digest, User.digest(remember_token))
  	end

  	# return true if token matches digest
  	# listing 9.6
  	def authenticated?(remember_token)
  		return false if remember_digest.nil? # listing 9.19
  		BCrypt::Password.new(remember_digest).is_password?(remember_token)
  	end

  	# forget a user
  	# listing 9.11
  	def forget
  		update_attribute(:remember_digest, nil)
  	end

end	
