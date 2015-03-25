Tolaria.configure do |config|

  # The default order to sort items on index pages.
  # "id DESC" will usually show newest things at the top of the list.
  config.default_sort_order = "id DESC"

  # The name of the admin interface as used in the system
  # navigation and HTML page titles.
  config.interface_title = "Company Name"

  # Tolaria sends emails for authentication.
  # Set the value of the email FROM field here.
  config.from_address = "Rails <tolaria@example.org>"

  # The default cost factor for bcrypt. Raising this number
  # will exponentially increase the wall clock time bcrypt takes
  # to hash a passphrase. Use 1 in test mode to speed things up.
  # It is VERY DANGEROUS to set this below 10 for any production code.
  config.bcrypt_cost = Rails.env.test?? 1 : 10

  # The number of seconds that emailed passcodes should be valid.
  # It is STRONGLY RECOMMENDED that you keep this under 30 minutes.
  config.passcode_lifespan = 10.minutes

  # The number of times an administrator can flunk their passcode
  # challenge or request a token before Tolaria disables their account.
  config.lockout_threshold = 6

  # The length of time that an administrator’s account is disabled
  # after they trip the lockout threshold.
  config.lockout_duration = 1.hour

  # The amount of time that an administrator’s login lasts.
  # Refreshed every time they return to the site.
  config.session_length = 3.weeks

  # Tolaria attempts to convert models to a pretty “display”
  # string for presenting in forms and listings.
  # The methods below are tried in order on models until one responds.
  # Must be an array of symbols.
  config.display_name_methods = %i[
    admin_name
    display_name
    full_name
    pretty_name
    title
    name
    label
    username
    login
    email
    to_s
    id
  ]

end
