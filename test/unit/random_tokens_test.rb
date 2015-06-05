require "test_helper"

class RandomTokensTest < ActiveSupport::TestCase

  test "generate a 32-character alphanumeric token" do
    assert_match /[A-z0-9]{32}/, Tolaria::RandomTokens.auth_token
  end

  test "generate a 6-digit passcode" do
    assert_match /[0-9]{6}/, Tolaria::RandomTokens.passcode
  end

end
