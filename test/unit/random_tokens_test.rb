require "test_helper"

class RandomTokensTest < ActiveSupport::TestCase

  test "a 32-character alphanumeric token should be generated" do
    assert_match /[A-z0-9]{32}/, Tolaria::RandomTokens.auth_token
  end

  test "a 6-digit passcode should be generated" do
    assert_match /[0-9]{6}/, Tolaria::RandomTokens.passcode
  end

end
