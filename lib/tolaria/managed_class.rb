# This class wraps an ActiveRecord::Base descendant
# and stores information that Tolaria needs to track about it

module Tolaria
  class ManagedClass

    # -------------------------------------------------------------------------
    # ATTRIBUTES
    # -------------------------------------------------------------------------

    # The ActiveRecord::Base model we’re managing
    attr_accessor :klass

    # The navigation category and order to use for this resource
    # Items are sorted with lowest priority first
    attr_accessor :category
    attr_accessor :priority

    # The FontAwesome icon to use for this resource
    attr_accessor :icon_name

    # An array of symbols to pass to params.permit for this model
    attr_accessor :permitted_params

    # An auto-generated controller name for this resource in the Admin namespace
    attr_accessor :controller_name

    # An array of the route actions allowed on this resource.
    # Tolaria will pass this array as the `only:` option to the router
    attr_accessor :allowed_actions

    # A stored symbol for the params.permit key for this resource
    attr_accessor :param_key

    # -------------------------------------------------------------------------
    # CREATE
    # A factory method that registers a new model in Tolaria and configures
    # its menu and param settings
    # -------------------------------------------------------------------------

    def self.create(klass, icon:"file-o", permit_params:[], priority:10, category:"Settings", actions:%i[index show new create edit update destroy])

      managed_class = self.new
      managed_class.klass = klass

      # Assign the passed in setting
      managed_class.icon_name = icon.to_s.freeze
      managed_class.priority = priority.to_i
      managed_class.category = category.to_s.freeze
      managed_class.permitted_params = permit_params.freeze
      managed_class.allowed_actions = actions.freeze

      # Set auto-generated attributes
      managed_class.controller_name = "#{managed_class.model_name.name.pluralize}Controller".freeze
      managed_class.param_key = managed_class.model_name.singular.to_sym

      return managed_class

    end

    # -------------------------------------------------------------------------
    # MODEL NAME
    # Defer to the ActiveRecord::Base model_name system for producing
    # pleasant user-interface names for this resource
    # -------------------------------------------------------------------------
    def model_name
      self.klass.model_name
    end

  end
end
