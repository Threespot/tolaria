module Tolaria

  @safe_mangagment = false
  @managed_classes = []

  # True if the application has actually booted
  # and Tolaria is safe to start referencing models
  def self.safe_management
    @safe_mangagment
  end

  # Set the value of Tolaria.safe_management. +bool+ should be truthy.
  # Don't call this method directly.
  def self.safe_management=(bool)
    @safe_mangagment = !!bool
  end

  # Tolaria keeps a list of all managed classes and the controllers
  # for those classes internally so that other parts of the system
  # can iterate over them. Return the list.
  def self.managed_classes
    @managed_classes
  end

  # Internal factory for adding managed classes. Developers should
  # use ActiveRecord::Base#manage_with_tolaria.
  def self.manage(klass, options = {})

    # If we already have a class of this name, discard it
    discard_managed_class(klass)

    # Wrap the Rails model inside a Tolaria::ManagedClass
    managed_klass = Tolaria::ManagedClass.create(klass, options)

    # Add class to the internal tracker
    @managed_classes.push(managed_klass)

    # Check if there is already a correctly named controller because
    # this means the end-developer made one and we don't want to unseat it.
    # Otherwise create a controller for the model to use in the admin namespace.
    unless "Admin::#{managed_klass.controller_name}".safe_constantize
      managed_controller = Class.new(Tolaria::ResourceController)
      ::Admin.const_set(managed_klass.controller_name, managed_controller)
    end

    return managed_klass

  end

  # Discard a managed class instance for the given ActiveRecord::Base
  def self.discard_managed_class(klass)
    @managed_classes.delete_if do |managed_class|
      klass.to_s == managed_class.klass.to_s
    end
  end

end
