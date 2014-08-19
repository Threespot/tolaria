module Tolaria
  class ManagedClass

    attr_accessor :klass
    attr_accessor :controller_name
    attr_accessor :string_representation
    attr_accessor :symbol_representation
    attr_accessor :icon_name

    def self.create(klass, options = {})

      managed_class = self.new
      managed_class.klass = klass

      managed_class.string_representation = options.fetch(:name, klass.to_s.titleize)
      managed_class.symbol_representation = options.fetch(:symbol, klass.to_s.tableize.to_sym)
      managed_class.controller_name = "#{klass.to_s.pluralize}Controller"

      managed_class.icon_name = options.fetch(:icon, :file_o).to_sym

      managed_class

    end

    alias_method :to_s, :string_representation
    alias_method :to_sym, :symbol_representation
    alias_method :intern, :symbol_representation

  end
end
