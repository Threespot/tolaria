# Adds a new DSL method to ActiveRecord model definition, allowing the
# developer to configure a model to be managed as a resource in Tolaria.
# The developer passes a hash of configuration options which are
# forwarded as keyword arguments to Tolaria.manage

class ActiveRecord::Base

  # Register a model with Tolaria and allow administrators to manage it
  def self.manage_with_tolaria(using:{})
    Tolaria.manage(self, **using)
  end

end
