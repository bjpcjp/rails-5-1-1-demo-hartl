require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  # microposts are accessed via their authors (users),
  # so :create & :destroy actions require users to be logged in.
  #

  # listing 13.31
  def setup
    @micropost = microposts(:orange)
  end

  # listing 13.31
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  # listing 13.31
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  # listing 13.54
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

end
