module Tolaria
  class Engine < ::Rails::Engine

    # Add Tolaria’s assets to config.assets.precompile
    initializer "tolaria.assets.precompile", group: :all do |app|
      app.config.assets.precompile += %w[
        admin/admin.css
        admin/admin.js
        admin/favicon.ico
      ]
    end

    # Reference ApplicationController and set Tolaria.safe_management
    # to indicate that the application has finished booting
    initializer "tolaria.safe_management", group: :all do |app|
      app.config.after_initialize do
        "ApplicationController".safe_constantize
        Tolaria.safe_management = true
      end
    end

  end
end
