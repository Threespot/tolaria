$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "tolaria/version"

Gem::Specification.new do |s|

  s.name          = "tolaria"
  s.version       = Tolaria::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.licenses      = ["MIT"]
  s.authors       = ["Corey Csuhta", "Daniel Boggs"]
  s.email         = "hello+tolaria@threespot.com"
  s.homepage      = "https://github.com/threespot/tolaria"
  s.summary       = "A Rails CMS framework for making people happy."
  s.description   = "Tolaria is a content management system (CMS) framework for Ruby on Rails. It greatly speeds up the necessary—but repetitive—task of creating useful admin panels, forms, and model workflow. Includes a library of rich form components, passwordless authentication, and text search tools. Make your editors happy!"

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
  s.add_development_dependency "yard", "~> 0.6"
  s.add_development_dependency "redcarpet", "~> 3"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "timecop", "~> 0.7"

end
