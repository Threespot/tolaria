require "test_helper"

class AdminControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::AdminController.new
  end

  test "should get redirected to signin form" do
    get :root
    assert_response :see_other
  end

  test "shouldn't render documents when logged out" do
    post :markdown, "This is nice"
    assert_response :not_found
  end

end
