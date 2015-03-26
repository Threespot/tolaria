class Administrator < ActiveRecord::Base

  before_create { generate_token(:auth_token) }

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :email,
    presence: true,
    uniqueness: true

  validates :name,
    presence: true

  validates :organization,
    presence: true

  # -----------------------------------------------------------------------------
  # Instance Methods
  # -----------------------------------------------------------------------------

  def authenticate(passcode)
    return false if self.locked?

    if BCrypt::Password.new(self.passcode) == passcode
      self.reset_strikes!
      Time.now < self.passcode_expires_at
    else
      self.accrue_strike!
      return false
    end
  end

  def locked?
    return false if self.account_unlocks_at.nil?
    Time.now < self.account_unlocks_at
  end

  def accrue_strike!
    self.update_attributes(lockout_strikes: self.lockout_strikes + 1, total_strikes: self.total_strikes + 1)
    if self.lockout_strikes >= Tolaria.config.lockout_threshold
      self.account_unlocks_at = Time.now + Tolaria.config.lockout_duration
      self.reset_strikes!
    end
  end

  def reset_strikes!
    self.update_attributes(lockout_strikes: 0)
  end

  def unlock_account!
    self.update_attributes(lockout_strikes: 0, account_unlocks_at: nil)
  end

  def set_passcode!
    passcode = "%06d" % SecureRandom.random_number(1_000_000)
    self.update_attributes(passcode: BCrypt::Password.create(passcode), passcode_expires_at: Time.now + Tolaria.config.passcode_lifespan)
    return passcode
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64[0..31]
    end while Administrator.exists?(column => self[column])
  end

end
