class PasscodeMailer < ActionMailer::Base

  default from:Tolaria.config.from_address

  def passcode(administrator, passcode)
    @administrator = administrator
    @passcode = passcode
    mail(to:administrator.email, subject:"#{Tolaria.config.company_name} Passcode")
  end

end
