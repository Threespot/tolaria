# Configuration for Tolaria, the admin framework for making people happy.

Tolaria.configure do |config|

  # The name of the company or group using this admin interface.
  # Used in system navigation, HTML page titles, and the copyright line.
  config.company_name = "Company Name"

  # Tolaria sends authentication emails. Set the value of the From header here.
  # This is NOT a trivial choice, you might have to get this address
  # whitelisted by your target companies.
  config.from_address = "Rails <tolaria@example.org>"

  # Redirect the administrator to this route by default when logging in
  # or when no other redirect makes sense.
  config.default_redirect = :admin_administrators

  # You can assign models to a category to group them on the navigation menu.
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
  # call MyMarkdownRenderer.render(document)
  # If you leave this setting nil, Tolaria will assume that you do not
  # plan to use the markdown_composer form field.
  config.markdown_renderer = nil

  # You can provide documentation links in the interface header by
  # configuring them below. Add hashes to the array, with these keys:
  #
  # To render a Markdown file, provide a `:title`, the URL fragment `:slug`
  # and a `:markdown_file` path to your Markdown document. The system
  # will automatically draw a route to this view for you and present your file,
  # using the renderer configured in config.markdown_renderer
  #
  # To link to an arbitrary route or URL, provide a `:title` and a `:link_to`.
  # Examples below:
  #
  # config.help_links << {
  #   title: "Markdown Reference",
  #   slug: "markdown-reference",
  #   markdown_file: "/path/to/your/file.md",
  # }
  #
  # config.help_links << {
  #   title: "Style Guide",
  #   link_to: "http://example.org/styleguide",
  # }

  # Tolaria attempts to convert model instances to a pretty “display”
  # string for presenting in forms, titles, and listings.
  # You can define `admin_name` on your model to set the string yourself,
  # or you can append your own preferred methods to the front
  # of Tolaria’s list like so:
  # config.display_name_methods.unshift(:method_name)

  # The number of items on each page when paginating models.
  # Raising this too high might make page loading very slow.
  # config.page_size = 15

  # ---------------------------------------------------------------------------
  # Change the following passcode and account paranoia settings with caution.
  # Defaults are shown in comments.
  # ---------------------------------------------------------------------------

  # The length of time, in seconds, that emailed passcodes should be valid.
  # It is STRONGLY RECOMMENDED that you keep this under 30 minutes.
  # config.passcode_lifespan = 10.minutes

  # The number of times an administrator can flunk their passcode challenge
  # or request a token before Tolaria rate-limits/locks their account.
  # config.lockout_threshold = 10

  # The length of time that an administrator’s account is disabled after
  # they trip the lockout threshold. There is no unlock strategy besides time.
  # For emergencies, you can manually call unlock_account! on the relevant administrator.
  # config.lockout_duration = 1.hour

  # The cost factor for bcrypt. Raising this number will increase the
  # wall clock time bcrypt takes to hash a passphrase.
  # It is VERY DANGEROUS to set this below 10 for production code.
  # Use 1 in test mode to speed up your test suite.
  # config.bcrypt_cost = Rails.env.test?? 1 : 13

end
