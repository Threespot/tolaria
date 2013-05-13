module Tolaria

  @configuration = OpenStruct.new

  def self.config
    @configuration
  end

  def self.configure(&block)
    yield @configuration
  end

end

