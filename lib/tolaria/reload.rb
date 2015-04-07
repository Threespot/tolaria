# Tolaria needs the latest and greatest copies of the models
# and admin settings at all times. This file is a bit of a hack
# so that we can trigger a code refresh whenever we need to.

module Tolaria

  def self.reload_app_folder!

    # KLUDGE: Reference the `Administrator` object so that Rails autoloads
    # it from the engine directory
    Administrator

    Dir["#{Rails.root}/app/models/*.rb", "#{Rails.root}/app/admin/*.rb"].each do |file|
      load file
    end

  end

end
