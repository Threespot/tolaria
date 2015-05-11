module Tolaria

  # To provide admin pane development magic, Tolaria provides this method
  # to force Rails to autoload/reload all model files.
  def self.reload_models!

    # Reference the `Administrator` object so that Rails autoloads
    # it from the engine directory
    Administrator

    # Reference each ActiveRecord::Base model so Rails
    # autoloads or reloads it.
    Dir["#{Rails.root}/app/models/*.rb"].each do |file|
      File.basename(file, ".rb").camelize.constantize
    end

  end

end
