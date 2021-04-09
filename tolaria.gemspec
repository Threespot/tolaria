$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tolaria/version"

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.licenses      = ["MIT"]
  s.authors       = ["Corey Csuhta", "Daniel Boggs"]
  s.email         = "hello@threespot.com"
  s.homepage      = "https://github.com/threespot/tolaria"
  s.summary       = "A Rails CMS framework for making people happy."
  s.description   = "Tolaria is a content management system (CMS) framework for Ruby on Rails. It greatly speeds up the necessary—but repetitive—task of creating useful admin panels, forms, and model workflow. Includes a library of rich form components, passwordless authentication, and text search tools. Make your editors happy!"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files --directory test`.split("\n")
  s.require_paths = ["lib"]


  s.required_ruby_version = ">= 2.6"

  s.add_dependency "bcrypt", "~> 3.1"
  s.add_dependency "kaminari", "~> 1.1.1"
  s.add_dependency "rails", "~> 6"
  s.add_dependency "ransack", "~> 2.3"
  s.add_dependency "sass-rails", "~> 6.0"
  s.add_dependency "sass", "~> 3.0"

  s.add_development_dependency "capybara", "~> 3.28"
  s.add_development_dependency "minitest", "~> 5.11"
  s.add_development_dependency "redcarpet", "~> 3"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "timecop", "~> 0.7"
  s.add_development_dependency "yard", "~> 0.6"

end
