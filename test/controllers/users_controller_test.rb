require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    #get users_new_url
    get signup_path # listing 5.44
    assert_response :success
  end

end
