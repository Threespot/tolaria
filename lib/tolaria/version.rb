module Tolaria

  # Returns Tolaria’s version number
  def self.version
    Gem::Version.new("1.2.0.pre")
  end

  module VERSION
    MAJOR, MINOR, TINY, PRE = Tolaria.version.segments
    STRING = Tolaria.version.to_s
  end

end
