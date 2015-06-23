module Tolaria

  # Tolaria’s configuration is a class so that an exception is raised
  # if you try to configure a key that doesn't exist.
  # Refer to the comments in the initializer that Tolaria generated for
  # you when you ran `rails generate tolaria:install`.
  class Configuration
    # The cost factor for bcrypt
    attr_accessor :bcrypt_cost
    # The name of the company using this admin interface
    attr_accessor :company_name
    # The default redirect path when administrators log in or no better path exists
    attr_accessor :default_redirect
    # An array of method names Tolaria uses to attempt to convert a model to a string
    attr_accessor :display_name_methods
    # The `From` header for emails Tolaria sends
    attr_accessor :from_address
    # An array of hashes for configuring Help Links
    attr_accessor :help_links
    # The number of seconds that an administrator is locked out when they hit the rate-limit
    attr_accessor :lockout_duration
    # The number of times an administrator can flunk their passcode challenge or request a token before Tolaria disables their account.
    attr_accessor :lockout_threshold
    # A string that names a Markdown renderer for Tolaria to use.
    attr_accessor :markdown_renderer
    # An array of configured menu category labels
    attr_accessor :menu_categories
    # The default page size Tolaria uses when paginating
    attr_accessor :page_size
    # The number of seconds that a generated passcode is valid
    attr_accessor :passcode_lifespan
    # The default array of permitted params (internal use only)
    attr_accessor :permitted_params
  end

  # Returns Tolaria’s configuration as an object
  def self.config
    if block_given?
      raise ArgumentError, "You passed a block to Tolaria.config but such a block will be ignored. Did you mean to call Tolaria.configure instead?"
    end
    @configuration ||= Tolaria::Configuration.new
  end

  # Configure Tolaria, block-style. Use something similar to:
  #
  #     Tolaria.configure do |config|
  #       # Assign to config properties here
  #     end
  def self.configure(&block)
    yield @configuration ||= Tolaria::Configuration.new
  end

end

