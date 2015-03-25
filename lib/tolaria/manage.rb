# Tolaria keeps a list of all managed classes and the controllers
# for those classes internally so that other parts of the system
# can iterate over them. Metaprogramming!

module Tolaria

  @managed_classes = []
  @managed_controllers = []

  def self.managed_classes
    @managed_classes
  end

  def self.managed_controllers
    @managed_controllers
  end

  # The developer calls `Tolaria.manage MyClass do ... end`
  def self.manage(klass, options = {}, &block)
    # If we already have a class of this name, discard it
    discard_managed_class(klass)
    # Wrap the Rails model inside a Tolaria::ManagedClass
    managed_klass = Tolaria::ManagedClass.create(klass, options)
    # Create a controller for the model to use in the admin namespace
    managed_controller = Class.new(Tolaria::ResourceController)
    ::Admin.const_set(managed_klass.controller_name, managed_controller)
    # Add these things to the internal tracker
    managed_classes.push(managed_klass)
    managed_controllers.push(managed_controller)
  end

  def self.discard_managed_class(klass)
    managed_classes.each do |managed_class|
      if klass == managed_class.klass
        managed_controllers.reject! do |controller|
          controller.to_s == "Admin::#{managed_class.controller_name}"
        end
        ::Admin.send(:remove_const, managed_class.controller_name)
        managed_classes.delete(managed_class)
        return true
      end
    end
    return false
  end

end
