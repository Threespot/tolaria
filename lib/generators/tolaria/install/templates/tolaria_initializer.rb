Tolaria.configure do |config|

  # The name of the admin interface as used in the system navigation
  # and HTML page titles. Usually the name of the company or org.
  config.interface_title = "Company Name"

  # Tolaria sends authentication emails. Set the value of the FROM field here.
  # This is NOT a trivial choice, you might have to get this address
  # whitelisted by your target companies.
  config.from_address = "Rails <tolaria@example.org>"

  # Redirect the administrator to this route by default when logging in.
  config.default_redirect = :admin_administrators

  # You can assign models to a category to group them on the admin menu.
  # Add/modify categories by changing the array below.
  # Categories will be in the same order in the menu as they are here.
  config.menu_categories = [
    # "Syndication",
    # "Pages",
    "Settings",
  ]

  # Tolaria does not come bundled with a Markdown processing strategy.
  # You must provide a string that names a Ruby constant that can process Markdown.
  # The constant must respond to render(document), returning a string of HTML.
  # For example: if you provide "MyMarkDownRenderer", Tolaria will
  # call MyMarkdownRenderer.render(document).
  # If you leave this setting nil, Tolaria will assume that you do not
  # plan to use the markdown_composer form field.
  config.markdown_renderer = nil

  # The cost factor for bcrypt. Raising this number will increase the
  # wall clock time bcrypt takes to hash a passphrase.
  # It is VERY DANGEROUS to set this below 10 for production.
  # Use 1 in test mode to speed up your test suite.
  # config.bcrypt_cost = Rails.env.test?? 1 : 12

  # The length of time that emailed passcodes should be valid.
  # It is STRONGLY RECOMMENDED that you keep this under 30 minutes.
  # config.passcode_lifespan = 10.minutes

  # The number of times an administrator can flunk their passcode
  # challenge or request a token before Tolaria disables their account.
  # config.lockout_threshold = 10

  # The length of time that an administrator’s account is disabled
  # after they trip the lockout threshold.
  # config.lockout_duration = 1.hour

  # Tolaria attempts to convert models to a pretty “display” string for
  # presenting in forms and listings. You can define `admin_name` or `to_s`
  # on your model to set the string yourself, or you can append your own
  # preferred methods to the front of Tolaria’s list:
  # config.display_name_methods.unshift(:method_name)

end
