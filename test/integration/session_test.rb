require "test_helper"

class SessionTest < ActionDispatch::IntegrationTest

  def setup
    @administrator = create_dummy_administrator!
    reset!
  end

  def fill_out_signin_form!(email:, passcode:)
    visit("/admin/signin")
    find("#session-form-email").set(email)
    find("#session-form-passcode", visible:false).set(passcode)
    find("#session-form-submit").click
  end

  # Assert that we landed back on the signin form with the rejection message showing
  def assert_failed_authentication!
    assert page.has_content?("wasn’t correct"), "should see rejection flash message"
    assert_equal "/admin/signin", current_path
  end

  test "should get redirected to the signin form" do
    visit("/admin")
    assert_equal "/admin/signin", current_path
    assert_equal 200, status_code
  end

  test "should get the signin form" do
    visit "/admin/signin"
    assert_equal 200, status_code
  end

  test "admin form fields should be empty" do
    visit "/admin/signin"
    assert_equal nil, find("#session-form-email").value()
    assert_equal nil, find("#session-form-passcode", visible:false).value()
  end

  test "session form doesn't explode when junk submitted" do
    post "/admin/signin", params:{
      a: "Z6b4y26r16eSz6w7qLef722MC1IGK36K",
      b: { c: "LKgagZfpIhQMV8xfKfwSalp3RO6Nm6e6" }
    }
    assert_response :see_other
    assert response["Location"].include?("signin")
  end

  test "can sign in with passcode" do
    sign_in_dummy_administrator!
    assert current_path.exclude?("/admin/signin")
  end

  test "can't sign in with bad passcode" do
    passcode = @administrator.set_passcode!
    fill_out_signin_form! email:@administrator.email, passcode:"bad passcode"
    assert_failed_authentication!
  end

  test "can't sign in with an expired passcode" do
    passcode = @administrator.set_passcode!
    Timecop.freeze(Time.current + Tolaria.config.passcode_lifespan + 1.second) do
      fill_out_signin_form! email:@administrator.email, passcode:passcode
      assert_failed_authentication!
    end
  end

  test "account gets locked and unlocks" do

    passcode = @administrator.set_passcode!

    Tolaria.config.lockout_threshold.times do |i|
      fill_out_signin_form! email:@administrator.email, passcode:"bad passcode"
      assert_failed_authentication!
    end

    fill_out_signin_form! email:@administrator.email, passcode:passcode
    assert_failed_authentication!

    @administrator.reload
    assert @administrator.locked?, "account should be locked"

    Timecop.freeze(Time.current + Tolaria.config.lockout_duration + 1.second) do
      refute @administrator.locked?, "account should unlock after duration"
    end

    @administrator.unlock_account!
    @administrator.reload
    refute @administrator.locked?, "account should be unlock when instructed"

  end

end
