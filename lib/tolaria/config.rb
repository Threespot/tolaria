module Tolaria

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
    @configuration ||= TolariaConfig.new
    yield @configuration
  end

end

