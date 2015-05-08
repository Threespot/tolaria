module Tolaria
  class Engine < ::Rails::Engine

    # Add Tolaria’s assets to config.assets.precompile
    initializer "Tolaria precompile hook", group: :all do |app|
      app.config.assets.precompile += %w[
        admin/admin.css
        admin/admin.js
        admin/lib/no.js
      ]
    end

  end
end
