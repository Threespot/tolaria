class Administrator < ActiveRecord::Base

  after_initialize :initialize_authentication!
  before_validation :normalize_email!

  # -----------------------------------------------------------------------------
  # VALIDATIONS
  # Use some extra validation redundancy
  # -----------------------------------------------------------------------------

  validates :email, {
    uniqueness: true,
    # Don't try to predict all of the possible crazy emails people can have
    # Just validate that there is one @ and at least one dot: *@*.*
    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  }

  # Require all user-visible fields
  validates_presence_of :name
  validates_presence_of :organization

  # Parts of the admin system should not be empty
  validates_presence_of :auth_token
  validates_presence_of :passcode
  validates_presence_of :passcode_expires_at
  validates_presence_of :account_unlocks_at

  # Downcase and strip whitespace from the current email
  def normalize_email!
    self.email = self.email.to_s.downcase.squish
  end

  # -----------------------------------------------------------------------------
  # AUTHENTICATION SYSTEM
  # The admin must request a passcode challenge via email
  # To pass the challenge, the admin must enter the correct email address
  # and passcode inside the time window
  # -----------------------------------------------------------------------------

  # Initialize +passcode+, +passcode_expires_at+,
  # +auth_token+, and +account_unlocks_at+ for a new admin.
  # To prevent passcode system fields from being null,
  # we fill them with an immediately expired passcode.
  def initialize_authentication!
    self.passcode ||= BCrypt::Password.create(Tolaria::RandomTokens.passcode, cost:Tolaria.config.bcrypt_cost)
    self.passcode_expires_at ||= Time.current
    self.auth_token ||= Tolaria::RandomTokens.auth_token
    self.account_unlocks_at ||= Time.current
  end

  # Send a passcode challenge email to the admin
  def send_passcode_email!
    plaintext_passcode = self.set_passcode!
    PasscodeMailer.passcode(self, plaintext_passcode).deliver_now
  end

  # Generate a new passcode challenge.
  # Create a passcode, save it, and set an expiration window.
  # Returns the plaintext passcode to send to the user.
  def set_passcode!
    plaintext_passcode = Tolaria::RandomTokens.passcode
    self.update!(
      passcode: BCrypt::Password.create(plaintext_passcode, cost:Tolaria.config.bcrypt_cost),
      passcode_expires_at: Time.current + Tolaria.config.passcode_lifespan,
    )
    return plaintext_passcode
  end

  # Attempt to authenticate the account with the given plaintext +passcode+.
  # Returns true if the passcode was valid, false otherwise.
  def authenticate!(passcode)

    # Always run bcrypt first so that we incur the time penalty
    bcrypt_valid = BCrypt::Password.new(self.passcode) == passcode

    # Reject if currently locked
    return false if self.locked?

    # Clear strikes and consume the passcode if the passcode was valid.
    # Reject and incur a strike if the challenge was failed.
    if bcrypt_valid && Time.current < self.passcode_expires_at
      self.consume_passcode!
      return true
    else
      self.accrue_strike!
      return false
    end

  end

  # Immediately expire the current passcode and reset lockout strikes.
  def consume_passcode!
    self.update!(
      passcode_expires_at: Time.current,
      lockout_strikes: 0,
    )
  end

  # Add one strike to the account.
  # An admin is given a strike for requesting a code or flunking a challenge.
  # Will lock the account if they’ve hit the threshold.
  def accrue_strike!
    self.update!(
      lockout_strikes: self.lockout_strikes + 1,
      total_strikes: self.total_strikes + 1,
    )
    if self.lockout_strikes >= Tolaria.config.lockout_threshold
      self.lock_account!
    end
  end

  # Lock this account immediately and reset lockout strikes.
  def lock_account!
    self.update!(
      account_unlocks_at: Time.current + Tolaria.config.lockout_duration,
      lockout_strikes: 0,
    )
  end

  # Unlock the user’s account. Currently only usable by someone
  # with Rails console access.
  def unlock_account!
    self.update!(
      account_unlocks_at: Time.current,
      lockout_strikes: 0,
    )
  end

  # True if the account is currently inside a lockout window
  def locked?
    return Time.current < self.account_unlocks_at
  end

  # -----------------------------------------------------------------------------
  # MANAGE
  # Register this model with Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "shield",
    category: "Settings",
    priority: 100,
    permit_params: %i[email name organization],
  }

end
