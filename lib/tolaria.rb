require "securerandom"
require "digest/md5"

require "sass"
require "sass-rails"
require "bcrypt"
require "kaminari"
require "ransack"

require "tolaria/version"
require "tolaria/engine"
require "tolaria/config"
require "tolaria/default_config"
require "tolaria/random_tokens"
require "tolaria/admin"

require "tolaria/reload"
require "tolaria/manage"
require "tolaria/active_record"
require "tolaria/routes"
require "tolaria/introspection"
require "tolaria/categories"
require "tolaria/markdown"
require "tolaria/form_buildable"

module Tolaria
  # We have to autoload these classes because they inherit
  # from a Rails class (Rails must boot first)
  autoload :TolariaController, "tolaria/controllers/tolaria_controller"
  autoload :ResourceController, "tolaria/controllers/resource_controller"
  autoload :ManagedClass, "tolaria/managed_class"
end
