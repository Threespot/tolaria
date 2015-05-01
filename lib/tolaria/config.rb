module Tolaria

  # Tolaria’s config is a class so that an exception is raised
  # if you try to configure a key that doesn't exist. See default_config.rb
  class Configuration
    attr_accessor :bcrypt_cost
    attr_accessor :default_sort_order
    attr_accessor :default_redirect
    attr_accessor :display_name_methods
    attr_accessor :from_address
    attr_accessor :interface_title
    attr_accessor :lockout_duration
    attr_accessor :lockout_threshold
    attr_accessor :markdown_renderer
    attr_accessor :passcode_lifespan
    attr_accessor :page_size
    attr_accessor :permitted_params
    attr_accessor :session_length
  end

  def self.config
    @configuration ||= Tolaria::Configuration.new
  end

  def self.configure(&block)
    yield @configuration ||= Tolaria::Configuration.new
  end

end

