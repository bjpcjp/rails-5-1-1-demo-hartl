require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  # listing 5.32 
  test "layout links" do
    get root_path
    assert_template 'go/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end
