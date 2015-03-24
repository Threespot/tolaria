module Tolaria
  module RandomTokens

    # Returns a login token in the form XXX-XXXX suitable for use
    # as a one-time passphrase
    def self.passcode
      SecureRandom.hex(4)[0..6].tr("f","x").insert(3,"-").upcase
    end

    # Returns a 32-character random token suitable for strong temporary keys
    def self.recovery
      SecureRandom.base64(32).delete("+/=")[0..32]
    end

  end
end
