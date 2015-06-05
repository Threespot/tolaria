require "test_helper"

class SessionTest < ActionDispatch::IntegrationTest

  def setup
    @administrator = create_dummy_administrator!
  end

  test "should get redirected to the signin form" do
    get "/admin"
    assert_response :see_other
  end

  test "should get the signin form" do
    get "/admin/signin"
    assert_response :success
  end

  test "session form doesn't explode when junk submitted" do
    post "/admin/signin", {
      a: "Z6b4y26r16eSz6w7qLef722MC1IGK36K",
      b: { c: "LKgagZfpIhQMV8xfKfwSalp3RO6Nm6e6" }
    }
    assert_response :see_other
    assert response["Location"].include?("signin")
  end

  test "can sign in with passcode" do
    sign_in_dummy_administrator!
    assert page.current_path.exclude?("/admin/signin")
  end

  test "can't sign in with bad passcode" do
    passcode = @administrator.set_passcode!
    post "/admin/signin", {
      administrator: {
        email: @administrator.email,
        passcode: "F#{passcode}"
      }
    }
    assert_response :see_other
    assert_redirected_to "/admin/signin"
  end

end

