module Tolaria
  class ResourceController < TolariaController

    # -------------------------------------------------------------------------
    # FILTERS/SETUP
    # -------------------------------------------------------------------------

    protect_from_forgery
    before_filter :add_admin_headers!
    before_filter :admin_setup!

    def add_admin_headers!
      # Don't use old IE rendering modes
      response.headers["X-UA-Compatible"] = "IE=edge"
      # Forbid putting the admin in a frameset/iframe
      response.headers["X-Frame-Options"] = "deny"
      # Strict sniffing and XSS modes for browsers that use these flags
      response.headers["X-Content-Type-Options"] = "nosniff"
      response.headers["X-XSS-Protection"] = "1; mode=block"
    end

    def admin_setup!
      # Noting here just yet.
    end

    # -------------------------------------------------------------------------
    # RESOURCE ACTIONS
    # -------------------------------------------------------------------------

    def index
      @resources = managed_class.klass.all
      render tolaria_template("index")
    end

    def show
      @resource = managed_class.klass.find_by_id(params[:id])
      render tolaria_template("show")
    end

    def new
      @resource = managed_class.klass.new
      render tolaria_template("new")
    end

    def create
      @resource = managed_class.klass.new
      @resource.assign_attributes(params[managed_class_symbol])
      if @resource.save
        redirect_to admin_resource_show_path(@resource)
      else
        flash.now[:error] = "There was a problem saving your #{managed_class}. Please review the messages below."
        render tolaria_template("new")
      end
    end

    def edit
      @resource = managed_class.klass.find_by_id(params[:id])
      render tolaria_template("edit")
    end

    def update
      @resource = managed_class.klass.find_by_id(params[:id])
      @resource.assign_attributes(params[managed_class_symbol])
      if @resource.save
        redirect_to admin_resource_update_path(@resource)
      else
        flash.now[:error] = "There was a problem saving your #{managed_class}. Please review the messages below."
        render tolaria_template("update")
      end
    end

    def destroy
      @resource = managed_class.klass.find_by_id(params[:id])
      begin
        @resource.destroy
      rescue ActiveRecord::DeleteRestrictionError => e
        flash[:error] = "You cannot delete that #{managed_class} because other items are using it."
        return redirect_to :index
      end
      flash[:notice] = "#{managed_class} deleted."
      redirect_to :index
    end

    protected

    def managed_class
      @managed_class ||= begin
        Tolaria.managed_classes.each do |managed_class|
          if self.class.to_s == "Admin::#{managed_class.controller_name}"
            return managed_class
          end
        end
      end
    end

    def tolaria_template(name)
      return {
        template: "admin/resource/#{name}",
        layout: "admin/layouts/admin"
      }
    end

  end
end
