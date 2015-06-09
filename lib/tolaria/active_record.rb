# Adds a new DSL method to ActiveRecord model definition, allowing the
# developer to configure a model to manage with Tolaria.
# The developer passes a hash of configuration options which are
# forwarded as keyword arguments to Tolaria.manage

class ActiveRecord::Base

  # Register a model with Tolaria and allow administrators to manage it
  # in the admin interface. Accepts one named parameter, +using+
  # which should be a Hash of options below.
  #
  # #### Options
  #
  # - `:category` - The navigation category to use for this resource.
  #   Should be one of the configured labels in Tolaria.config.menu_categories.
  #   The default is `"Settings"`.
  # - `:priority` - The priority for this item in its menu category.
  #   Items with lower priority are sorted first.
  #   The default is 10.
  # - `:icon` - The Font Awesome icon to use for this model.
  #   Should be one of the names on the Font Awesome site at
  #   http://fortawesome.github.io/Font-Awesome/icons/
  #   The default is `"file-o"`.
  # - `:permitted_params` - A array of parameter names to pass to
  #   `params.permit()` for this model/form.
  #   The default is an empty array. You will need to set this option to
  #   match the fields you included on your admin form.
  # - `:default_order` - The default `order()` for sorting this
  #   model when no other sorting is happening.
  #   The default is `"id DESC"`.
  # - `:paginated` - If `true`, Tolaria will apply the default
  #   pagination controls/system to the model. Set to `false` to disable.
  #   The default is `true`.
  # - `:allowed_actions` - The router actions to draw for this model.
  #   Only set this value yourself if you are overriding or forbidding some
  #   route construction.
  #   Tolaria will pass this array as the `only:` option to the router.
  #   The default includes all CRUD actions:
  #   `[:index, :show, :new, :create, :edit, :update, :destroy]`
  def self.manage_with_tolaria(using:{})
    @tolaria_management_options = using
    if Tolaria.safe_management
      generate_tolaria_bindings!
    end
  end

  # Instructs Tolaria to start managing the model and create the correct controllers.
  # You shouldn't call this method directly.
  def self.generate_tolaria_bindings!
    if @tolaria_management_options.present?
      Tolaria.manage(self, **@tolaria_management_options)
    end
  end

end
