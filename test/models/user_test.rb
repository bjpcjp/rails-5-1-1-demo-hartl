require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # listing 6.5
  def setup
  	@user = User.new(
  		name: "example user", 
  		email: "user@example.com",
  		password: 'foobar',
  		password_confirmation: 'foobar'
  		)
  end

  test "should be valid" do
  	assert @user.valid?
  end
 
  test "name should be present" do # listing 6.7
  	@user.name = "    "
  	assert_not @user.valid?
  end

  test "name length should be a max of 50 chars" do # listing 6.14
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do # listing 6.11
  	@user.email = "    "
  	assert_not @user.valid?
  end

  test "email length should be a max of 50 chars" do # listing 6.14
    @user.email = "a" * 51 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do # listing 6.18
    valid_addresses = %w[
    	user@example.com 
    	USER@foo.COM 
    	A_US-ER@foo.bar.org
        first.last@foo.jp 
        alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do # listing 6.19
    invalid_addresses = %w[
    	user@example,com 
    	user_at_foo.org 
    	user.name@example.
        foo@bar_baz.com 
        foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do # listing 6.24
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase # listing 6.26
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be nonblank" do # listing 6.41
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password length should be at least 6 chars" do # listing 6.41
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # listing 9.17
  test "authenticated? should return false for a user with nil digest" do
    #assert_not @user.authenticated?('')
    # listing 11.29
    assert_not @user.authenticated?(:remember, '')
  end

  # listing 13.20
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # listing 14.9
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)

    assert_not michael.following?(archer)

    michael.follow(archer)
    assert michael.following?(archer)

    assert archer.followers.include?(michael) # listing 14.13

    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

=begin requirements:
* posts for followed users should be in the feed.
* posts for the user should be in the feed.
* posts from unfollowed users should NOT be in the feed.  
=end

  # listing 14.42
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end

    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end

  end

end
