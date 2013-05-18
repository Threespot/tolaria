require "bourbon"
require "devise"
require "formtastic"
require "ostruct"
require "sass"
require "securerandom"

require "tolaria/version"
require "tolaria/engine"
require "tolaria/config"
require "tolaria/default_configuration"

require "tolaria/fontawesome_map"

require "tolaria/admin"
require "tolaria/manage"
require "tolaria/routes"

module Tolaria
  autoload :ResourceController, "tolaria/resource_controller"
  autoload :ManagedClass, "tolaria/managed_class"
end
