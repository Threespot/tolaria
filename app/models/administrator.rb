class Administrator < ActiveRecord::Base

  before_validation :initialize_authentication!

  # -----------------------------------------------------------------------------
  # VALIDATIONS
  # Use some extra validation redundancy
  # -----------------------------------------------------------------------------

  validates :email, {
    presence: true,
    uniqueness: true
  }

  validates :name, {
    presence: true
  }

  validates :organization, {
    presence: true
  }

  validates :auth_token, {
    presence: true
  }

  validates :passcode, {
    presence: true
  }

  validates :passcode_expires_at, {
    presence: true
  }

  # -----------------------------------------------------------------------------
  # AUTHENTICATION SYSTEM
  # The admin must requiest a passcode challenge via email
  # To pass the challenge, the admin must enter the correct email address
  # and passcode inside the time window
  # -----------------------------------------------------------------------------

  # Create an auth_token for new admins
  # Prevent passcode fields from being null: create an already expired code
  def initialize_authentication!
    self.passcode ||= BCrypt::Password.create(Tolaria::RandomTokens.passcode, cost:Tolaria.config.bcrypt_cost)
    self.passcode_expires_at ||= Time.current
    self.auth_token ||= Tolaria::RandomTokens.auth_token
    self.account_unlocks_at ||= Time.current
  end

  # Send a passcode challenge to the admin
  def send_passcode_email!
    plaintext_passcode = self.set_passcode!
    PasscodeMailer.passcode(self, plaintext_passcode).deliver_now
  end

  # Generate a new passcode challenge.
  # Create a passcode, save it, and set an expiration window.
  def set_passcode!
    plaintext_passcode = Tolaria::RandomTokens.passcode
    self.update!(
      passcode: BCrypt::Password.create(plaintext_passcode, cost:Tolaria.config.bcrypt_cost),
      passcode_expires_at: Time.current + Tolaria.config.passcode_lifespan,
    )
    return plaintext_passcode
  end

  # Attempt to authenticate the admin
  def authenticate!(passcode)

    # Always run bcrypt first so that we incur the time pentaly
    bcrypt_valid = BCrypt::Password.new(self.passcode) == passcode

    # Reject if currently locked
    return false if self.locked?

    # Clear strikes and consume the passcode if the passcode was valid
    # Reject and incur a strike if the challenge was failed
    if bcrypt_valid && Time.current < self.passcode_expires_at
      self.consume_passcode!
      return true
    else
      self.accrue_strike!
      return false
    end

  end

  # When the user authenticates successfully, expire the passcode and
  # reset their account strikes
  def consume_passcode!
    self.update!(
      passcode_expires_at: Time.current,
      lockout_strikes: 0,
    )
  end

  # Add one strike to the account.
  # An admin is given a strike for requesting a code or flunking a challenge.
  # Lock the account if they’ve hit the threshold.
  def accrue_strike!
    self.update!(
      lockout_strikes: self.lockout_strikes + 1,
      total_strikes: self.total_strikes + 1,
    )
    if self.lockout_strikes >= Tolaria.config.lockout_threshold
      self.lock_account!
    end
  end

  # This user hit the strike threshold.
  # Lock their account and reset strikes.
  def lock_account!
    self.update!(
      account_unlocks_at: Time.now + Tolaria.config.lockout_duration,
      lockout_strikes: 0,
    )
  end

  # Unlock the user’s account, currently only useful for someone
  # with Rails console access.
  def unlock_account!
    self.update!(
      account_unlocks_at: Time.current,
      lockout_strikes: 0,
    )
  end

  # True if currently inside the lock window
  def locked?
    return Time.current < self.account_unlocks_at
  end

end
