$:.push File.expand_path("../lib", __FILE__)
require 'tolaria/version'

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.license       = "MIT"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Corey Csuhta"]
  s.homepage      = "https://github.com/csuhta/tolaria"
  s.description   = "Tolaria is a seriously opinionated Rails CMS framework for making your clients happy."
  s.summary       = "Tolaria is an opinionated Rails CMS interface."

  s.required_ruby_version     = ">= 2.0.0"
  s.required_rubygems_version = ">= 2.0.0"

  s.files = `git ls-files`.split("\n")
  s.require_paths = %w[lib]

  s.add_dependency "devise"
  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "railties", "~> 3.1"
  s.add_dependency "formtastic"

end
