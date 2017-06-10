require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:michael)
  	@other_user = users(:archer)
  end

=begin 
* Protect index page from unauthorized access.
* verify that index action is redirected properly.
=end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    #get users_new_url
    get signup_path # listing 5.44
    assert_response :success
  end

=begin 
before_filter operates on per-action basis.
* hit edit & update actions & verify flash is set, user is redirected to login path. 
* use GET and PATCH actions. 
=end

  # listing 10.20
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

=begin 
* users should only be allowed to edit their own information.
* To test, we need to be able to log in as 2nd user. 
* This means adding 2nd user to our users fixture file.
* Expect to redirect users to root path (not login path)
  because a user trying to edit a different user would already be logged in.
=end

  # listing 10.24
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

=begin 
* case 1: users who aren’t logged in:             redirected to login page
* case 2: users who are logged in and not admins: redirected to home page
=end

  # listing 10.61
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # listing 14.24: looks for authorization of following & followers pages.
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
