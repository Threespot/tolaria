module Tolaria

  # To provide admin pane development magic, Tolaria has this method
  # to force Rails to autoload/reload all model files.
  def self.reload!

    # Reference the `Administrator` class so that Rails autoloads
    # it from the engine directory
    Administrator

    # Reference each ActiveRecord::Base model so Rails
    # autoloads it or reloads changed files.
    Dir["#{Rails.root}/app/models/*.rb"].each do |file|
      File.basename(file, ".rb").camelize.safe_constantize
    end

  end

end
