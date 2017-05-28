require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # listing 8.26 -- return true if test user is logged in
  def is_logged_in?
  	!session[:user_id].nil?
  end

  # listing 9.24 -- Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# listing 9.24

=begin
Because it’s located inside the ActionDispatch::IntegrationTest class, 
this is the version of log_in_as that will be called inside integration tests. 

We use the same method name in both cases because 
it lets us do things like use code from a controller test 
in an integration without making any changes to the login method.
=end

class ActionDispatch::IntegrationTest

  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end