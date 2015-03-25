module Tolaria

  # Tolaria’s config is a Struct so that an exception is raised
  # if you try to configure a key that doesn't exist. See default_config.rb
  TolariaConfig = Struct.new(
    :bcrypt_cost,
    :default_sort_order,
    :display_name_methods,
    :from_address,
    :interface_title,
    :lockout_duration,
    :lockout_threshold,
    :passcode_lifespan,
    :session_length,
  )

  def self.config
    @configuration ||= TolariaConfig.new
  end

  def self.configure(&block)
    yield self.config
  end

end

