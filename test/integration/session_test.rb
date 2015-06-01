require "test_helper"

class SessionTest < ActionDispatch::IntegrationTest

  def setup
    @administrator = Administrator.find_or_create_by!({
      name: "Dummy User",
      organization: "Dummy Company",
      email: "corey.csuhta@threespot.com",
    })
  end

  test "does't blow up when garbage is submitted" do
    post "/admin/signin", {
      a: "Z6b4y26r16eSz6w7qLef722MC1IGK36K",
      b: { c: "LKgagZfpIhQMV8xfKfwSalp3RO6Nm6e6" }
    }
    assert_response 303
    assert response["Location"].include?("signin")
  end

  test "can login with passcode" do
    passcode = @administrator.set_passcode!
    post "/admin/signin", {
      administrator: {
        email: @administrator.email,
        passcode: passcode
      }
    }
    assert_response 303
    assert response["Location"].exclude?("signin")
  end

end

