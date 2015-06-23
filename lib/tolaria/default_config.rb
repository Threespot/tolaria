# This file initializes Tolaria's default configuration, which the developer
# is expected to override.
#
# Please see lib/generators/tolaria/install/templates/tolaria_initializer.rb
# and config.rb for details.

Tolaria.configure do |config|

  config.company_name = "Company Name"
  config.from_address = "Rails <tolaria@example.org>"

  config.default_redirect = :admin_administrators

  config.menu_categories = ["Settings"]

  config.bcrypt_cost = Rails.env.test?? 1 : 13
  config.passcode_lifespan = 10.minutes
  config.lockout_threshold = 10
  config.lockout_duration = 1.hour

  config.help_links = []

  config.markdown_renderer = nil
  config.page_size = 15

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

  config.permitted_params = %i[
    _method
    authenticity_token
    id
    utf8
  ]

end
