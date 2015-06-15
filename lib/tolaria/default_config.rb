Tolaria.configure do |config|

  # The name of the company or group using this admin interface.
  # Used in system navigation and HTML page titles.
  config.company_name = "Company Name"

  # Redirect the users to this route by default when logging in.
  config.default_redirect = :admin_administrators

  # Tolaria sends authentication emails. Set the value of the From header here.
  config.from_address = "Rails <tolaria@example.org>"

  # You can assign models to a category group them on the nav menu.
  # Add/modify categories by changing the array below.
  # Categories first in the array will be first on the menu.
  config.menu_categories = ["Settings"]

  # The cost factor for bcrypt.
  # It is VERY DANGEROUS to set this below 10 for production.
  # Use 1 in test mode to speed up your test suite.
  config.bcrypt_cost = Rails.env.test?? 1 : 13

  # The length of time that emailed passcodes should be valid.
  # It is STRONGLY RECOMMENDED that you keep this under 30 minutes.
  config.passcode_lifespan = 10.minutes

  # The number of times an administrator can flunk their passcode
  # challenge or request a token before Tolaria disables their account.
  config.lockout_threshold = 10

  # The length of time that an administrator’s account is disabled
  # after they trip the lockout threshold.
  config.lockout_duration = 1.hour

  # An array of hashes used to construct HelpLinks
  config.help_links = []

  # Tolaria does not come bundled with a Markdown processing strategy.
  # You must provide a string that names a Ruby constant that can process Markdown.
  # The constant must respond to render(document), returning a string of HTML.
  # For example: if you provide "MyMarkDownRenderer", Tolaria will
  # call MyMarkdownRenderer.render(document).
  config.markdown_renderer = nil

  # Tolaria attempts to convert models to a pretty “display”
  # string for presenting in forms and listings.
  # The methods below are tried in order on models until one responds.
  # Must be an array of symbols.
  config.display_name_methods = %i[
    admin_name
    display_name
    title
    name
    label
    username
    login
    email
    to_s
    id
  ]

  # The number of items on each page when paginating models.
  config.page_size = 15

  # Default permitted_params for all forms.
  # End-developers probably shouldn’t change this.
  config.permitted_params = %i[
    _method
    authenticity_token
    id
    utf8
  ]

end
