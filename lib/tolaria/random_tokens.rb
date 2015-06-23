module Tolaria
  module RandomTokens

    # Returns a 32-character random, alphanumeric string suitable for stronger
    # token use like with cookies and API keys.
    def self.auth_token
      SecureRandom.base64(32).delete("+/=")[0..31]
    end

    # Returns a six-digit numeric code suitable for use as a one-time passphrase.
    # Leading zeroes are possible, encompassing `000000`-`999999`.
    def self.passcode
      "%06d" % SecureRandom.random_number(1_000_000)
    end

  end
end
