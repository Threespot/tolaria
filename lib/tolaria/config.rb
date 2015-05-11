module Tolaria

  # Tolaria’s config is a class so that an exception is raised
  # if you try to configure a key that doesn't exist. See default_config.rb
  class Configuration
    attr_accessor :bcrypt_cost
    attr_accessor :default_redirect
    attr_accessor :display_name_methods
    attr_accessor :from_address
    attr_accessor :company_name
    attr_accessor :lockout_duration
    attr_accessor :lockout_threshold
    attr_accessor :markdown_renderer
    attr_accessor :menu_categories
    attr_accessor :page_size
    attr_accessor :passcode_lifespan
    attr_accessor :permitted_params
    attr_accessor :session_length
  end

  # Returns Tolaria’s configuration as an object
  def self.config
    @configuration ||= Tolaria::Configuration.new
  end

  # Configure Tolaria, block-style. Use something similar to:
  #
  #    Tolaria.configure |config| do
  #       # Assign to config properties here
  #    end
  #
  def self.configure(&block)
    yield @configuration ||= Tolaria::Configuration.new
  end

end

