class User < ApplicationRecord

	attr_accessor :remember_token 					        # listing 9.3

=begin 
* activation links sent via email & "clicked" via browser (GET, not PATCH).
* use public attribute (virtual) with secure hash design (stored in DB).
=end

  attr_accessor :activation_token                 # listing 11.3
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
