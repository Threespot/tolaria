require "test_helper"

class SessionsControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::SessionsController.new
  end

  test "should get signin form" do
    get :new
    assert_response :success
  end

end
