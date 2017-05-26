require 'test_helper'

def setup
	@app_title = "Demo"
end

class GoControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get go_home_url
    assert_response :success
    assert_select "title", "Demo | Home"
  end

  test "should get help" do
    get go_help_url
    assert_response :success
    assert_select "title", "Demo | Help"
  end

  # listing 3.15
  test "should get about" do
  	get go_about_url
  	assert_response :success
    assert_select "title", "Demo | About"
  end

end
