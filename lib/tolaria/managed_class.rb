# This class wraps an ActiveRecord::Base descendant
# and stores information that Tolaria needs to track about it

module Tolaria
  class ManagedClass

    attr_accessor :klass
    attr_accessor :controller_name
    attr_accessor :icon_name

    def self.create(klass, options = {})

      managed_class = self.new
      managed_class.klass = klass

      managed_class.controller_name = "#{managed_class.model_name.name.pluralize}Controller"
      managed_class.icon_name = options.fetch(:icon, :file_o).to_sym

      return managed_class

    end

    def model_name
      self.klass.model_name
    end

  end
end
