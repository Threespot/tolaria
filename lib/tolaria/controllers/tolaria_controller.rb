module Tolaria
  class TolariaController < ApplicationController

    protect_from_forgery
    before_filter :add_admin_headers!
    before_filter :admin_setup!

    def add_admin_headers!
      # Don't use old IE rendering modes
      response.headers["X-UA-Compatible"] = "IE=edge"
      # Forbid putting the admin in a frameset/iframe
      response.headers["X-Frame-Options"] = "DENY"
      # Strict sniffing and XSS modes for browsers that use these flags
      response.headers["X-Content-Type-Options"] = "nosniff"
      response.headers["X-XSS-Protection"] = "1; mode=block"
    end

    def admin_setup!
      # Nothing here just yet.
    end

    def tolaria_template(name)
      return {
        template: "admin/tolaria_resource/#{name}",
        layout: "admin/layouts/admin"
      }
    end

  end
end
