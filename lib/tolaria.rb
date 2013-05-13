require "bourbon"
require "devise"
require "ostruct"
require "sass"
require "securerandom"

require "tolaria/engine"
require "tolaria/config"
require "tolaria/default_configuration"
require "tolaria/admin"
require "tolaria/manage"
require "tolaria/routes"

module Tolaria

  autoload :VERSION,            "tolaria/version"
  autoload :ManagedClass,       "tolaria/managed_class"
  autoload :ViewHelpers,        "tolaria/view_helpers"
  autoload :ResourceController, "tolaria/resource_controller"

end
