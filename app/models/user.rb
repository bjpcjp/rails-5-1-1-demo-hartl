class User < ApplicationRecord

	validates :name, # listing 6.9
		presence: true,
		length: { maximum: 50 } # listing 6.16
	

  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  	before_save { self.email = email.downcase } # listing 6.32

	validates :email, # listing 6.12
		presence: true ,
		length: { maximum: 50 }, # listing 6.16
		format: { with: VALID_EMAIL_REGEX }, # listing 6.21
		uniqueness: { case_sensitive: false } # listing 6.25, 6.27

	has_secure_password
  	validates :password, # listing 6.42
  		presence: true, 
  		length: { minimum: 6 }

  	# return hash digest of given string.
  	# listing 8.21
  	def User.digest(str)
  		cost = ActiveModel::SecurePassword.min_cost ? 
  		BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  		BCrypt::Password.create(str, cost: cost)
  	end

end	
