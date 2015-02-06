module Tolaria

  TolariaConfig = Struct.new(
    "TolariaConfig",
    :route_prefix,
    :default_sort_order,
    :company_name,
    :interface_title,
    :markdown_header_delta,
    :display_name_methods,
    :markdown_options,
  )

  def self.config
    @configuration ||= TolariaConfig.new
  end

  def self.configure(&block)
    @configuration ||= TolariaConfig.new
    yield @configuration
  end

end

