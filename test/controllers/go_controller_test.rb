require 'test_helper'

def setup
	@app_title = "Demo"
end

class GoControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path # listing 5.28
    assert_response :success
    assert_select "title", "Demo | Home"
  end

  test "should get help" do
    get help_path # listing 5.28
    assert_response :success
    assert_select "title", "Demo | Help"
  end

  # listing 3.15
  test "should get about" do
  	get about_path # listing 5.28
  	assert_response :success
    assert_select "title", "Demo | About"
  end

  # listing 5.21
  test "should get contact" do
    get contact_path # listing 5.28
    assert_response :success
    assert_select "title", "Demo | Contact"
  end

end
