module Tolaria
  class ResourceController < TolariaController

    before_filter :load_managed_class

    # -------------------------------------------------------------------------
    # RESOURCE ACTIONS
    # -------------------------------------------------------------------------

    def index
      @resource = @managed_class.klass
      @resources = @managed_class.klass.all
      render tolaria_template("index")
    end

    def show
      @resource = @managed_class.klass.find_by_id(params[:id])
      render tolaria_template("show")
    end

    def new
      @resource = @managed_class.klass.new
      render tolaria_template("new")
    end

    def create
      @resource = @managed_class.klass.new
      @resource.assign_attributes(params[@resource.model_name.singular.to_sym])
      if @resource.save
        redirect_to admin_resource_show_path(@resource)
      else
        flash.now[:error] = "There was a problem saving your #{@managed_class}. Please review the messages below."
        render tolaria_template("new")
      end
    end

    def edit
      @resource = @managed_class.klass.find_by_id(params[:id])
      render tolaria_template("edit")
    end

    def update
      @resource = @managed_class.klass.find_by_id(params[:id])
      @resource.assign_attributes(params[@resource.model_name.singular.to_sym])
      if @resource.save
        redirect_to admin_resource_update_path(@resource)
      else
        flash.now[:error] = "There was a problem saving your #{managed_class}. Please review the messages below."
        render tolaria_template("update")
      end
    end

    def destroy
      @resource = @managed_class.klass.find_by_id(params[:id])
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

    def load_managed_class
      Tolaria.managed_classes.each do |managed_class|
        if self.class.to_s == "Admin::#{managed_class.controller_name}"
          @managed_class = managed_class
        end
      end
    end

  end
end
