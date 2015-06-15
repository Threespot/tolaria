module Tolaria

  # To provide admin pane development magic, Tolaria has this method
  # to force Rails to autoload/reload all model files.
  def self.reload!

    # Re/Initalize HelpLinks
    self.initialize_help_links!

    # Manage the models included with the engine
    Administrator.generate_tolaria_bindings!

    # Reference each ActiveRecord::Base model so Rails autoloads it or
    # reloads changed files. Call generate_tolaria_bindings! on them.
    Dir["#{Rails.root}/app/models/*.rb"].each do |file|
      File.basename(file, ".rb").camelize.safe_constantize.try(:generate_tolaria_bindings!)
    end

  end

end
