require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # listing 11.33
  def setup
    ActionMailer::Base.deliveries.clear
  end

  # listing 7.23
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  # listing 7.33, 11.24, 11.33
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    #
    assert_equal 1, ActionMailer::Base.deliveries.size  # only 1 msg delivered?
    user = assigns(:user)
    assert_not user.activated?
    #
    log_in_as(user)                           # try login before activation
    assert_not is_logged_in?
    #
    get edit_account_activation_path(         # invalid activation token
      "invalid token", email: user.email)
    assert_not is_logged_in?
    #
    get edit_account_activation_path(         # valid token, but wrong email
      user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    #
    get edit_account_activation_path(         # valid activation token
      user.activation_token, email: user.email)
    assert user.reload.activated?
    
    follow_redirect!                          # logged in?
    assert_template 'users/show'
    assert is_logged_in?
  end

end
