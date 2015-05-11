$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tolaria/version"

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Threespot Media"]
  s.licenses      = ["MIT"]
  s.homepage      = "https://github.com/threespot/tolaria"
  s.description   = "Tolaria is a seriously opinionated Rails CMS framework for making people happy."
  s.summary       = "Tolaria is an opinionated Rails CMS framework."

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.2.0"

  s.add_dependency "bcrypt", "~> 3.1"
  s.add_dependency "kaminari", "~> 0.16"
  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "ransack", "~> 1.6"
  s.add_dependency "sass", "~> 3.3"
  s.add_dependency "sass-rails", "~> 5.0"

  s.add_development_dependency "sdoc"
  s.add_development_dependency "minitest"

end
