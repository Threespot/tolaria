require "rails/generators/migration"

module Tolaria
  class InstallGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def install
      copy_file "tolaria_initializer.rb", "config/initializers/tolaria.rb"
      migration_template "administrators_migration.rb", "db/migrate/create_administrators.rb"
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.current.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
