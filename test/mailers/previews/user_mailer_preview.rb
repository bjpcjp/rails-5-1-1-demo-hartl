# Preview all emails at 
# http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

=begin 
* 'account_activation' needs valid user object,
	so use 1st user in development DB for now.
* 'user.activation_token' needs initialized (is a virtual attribute,
	so user in DB doesn't have one.)
=end

  # Preview this email at 
  # http://localhost:3000/rails/mailers/user_mailer/account_activation

  def account_activation    # listing 11.18
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at 
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
