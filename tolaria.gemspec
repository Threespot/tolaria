$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tolaria/version"

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Corey Csuhta", "Daniel Boggs"]
  s.licenses      = ["MIT"]
  s.homepage      = "https://github.com/threespot/tolaria"
  s.description   = "Tolaria is a CMS framework for Ruby on Rails. Make your editors happy!"
  s.summary       = "A Rails CMS framework for making people happy."

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files --directory test`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.2"

  s.add_dependency "bcrypt", "~> 3.1"
  s.add_dependency "kaminari", "~> 0.16"
  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "ransack", "~> 1.6"
  s.add_dependency "sass", "~> 3"
  s.add_dependency "sass-rails", "~> 5.0"

  s.add_development_dependency "capybara", "~> 2.4"
  s.add_development_dependency "minitest", "~> 5.7"
  s.add_development_dependency "rdoc", "~> 4"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "timecop", "~> 0.7"

end
