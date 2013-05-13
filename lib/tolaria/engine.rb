module Tolaria
  class Engine < ::Rails::Engine

    if Rails.version > "3.1"
      initializer "Tolaria precompile hook", group: :all do |app|
        app.config.assets.precompile += %w[
          tolaria.css
          tolaria.js
          custom.js
          lib/*.js
          modules/*.js
        ]
      end
    end

  end
end
