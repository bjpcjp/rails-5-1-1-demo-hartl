require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  # listing 10.9
  def setup
    @user = users(:michael)
  end

=begin 
verifies edit template is rendered after getting the edit page,
and re-rendered if invalid info submitted. 
Note use of PATCH method.
=end

  test "unsuccessful edit" do
  	log_in_as(@user) # listing 10.17
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end

=begin 
* Check for a nonempty flash message and successful redirect to profile page
* Verify user’s info correctly changed in DB. 
* Password and confirmation in are blank = convenient for users who don’t 
want to update passwords every time they update names or emails. N
* Note use of @user.reload reload user’s values from DB & confirm
successful update. 
=end

=begin replaced in listing 10.29
  test "successful edit" do # listing 10.11
  	log_in_as(@user) # listing 10.17
    get edit_user_path(@user)
    assert_template 'users/edit'
=end
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
=begin 
* When users try to access a protected page, they are currently redirected 
to their profile pages (regardless of intended URL). 
In other words, if a non-logged-in user tries to visit the edit page, 
after logging in the user will be redirected to /users/1 instead of /users/1/edit. 
It would be much friendlier to redirect them to their intended destination instead.

* Simple test: reversing order of login & visiting edit page.
=end
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
