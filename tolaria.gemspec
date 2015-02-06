$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tolaria/version"

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Corey Csuhta"]
  s.licenses      = ["MIT"]
  s.homepage      = "https://github.com/csuhta/tolaria"
  s.description   = "Tolaria is a seriously opinionated Rails CMS framework for making people happy."
  s.summary       = "Tolaria is an opinionated Rails CMS framework."

  s.files = Dir["lib/**/*.rb"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.1.5"

  s.add_dependency "clearance"
  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "redcarpet"
  s.add_dependency "sass-rails"

end
