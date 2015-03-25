module Tolaria
  module RandomTokens

    # Returns a 32-character random token suitable for stronger temporary keys
    def self.auth_token
      SecureRandom.base64(32).delete("+/=")[0..32]
    end

    # Returns a six-digit numeric passcode suitable for use
    # as a one-time passphrase
    def self.passcode
      "%06d" % SecureRandom.random_number(1_000_000)
    end

  end
end
