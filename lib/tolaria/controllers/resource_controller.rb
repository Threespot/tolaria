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
      @resource_name = Tolaria.display_name(@resource)

      if @resource.save
        flash.now[:success] = "Done! You created the #{@managed_class.model_name.human} “#{@resource_name}”."
        return redirect_to admin_resource_show_path(@resource)
      else
        flash.now[:error] = "Your changes couldn’t be saved. Please review the messages below."
        return render tolaria_template("new")
      end

    end

    def edit
      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      return render tolaria_template("edit")
    end

    def update

      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      @resource.assign_attributes(params[@resource.model_name.singular.to_sym])
      @resource_name = Tolaria.display_name(@resource)

      if @resource.save
        flash.now[:success] = "Done! You updated the #{@managed_class.model_name.human} “#{@resource_name}”."
        return redirect_to admin_resource_update_path(@resource)
      else
        flash.now[:error] = "Your changes couldn’t be saved. Please review the messages below."
        return render tolaria_template("update")
      end

    end

    def destroy

      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      @resource_name = Tolaria.display_name(@resource)

      begin
        @resource.destroy
      rescue ActiveRecord::DeleteRestrictionError => e
        flash[:restricted] = "You cannot delete “#{@resource_name}” because other items are using it."
        return redirect_to :index
      end

      flash[:destructive] = "You delet ed the #{@managed_class.model_name.human} “#{@resource_name}”."
      return redirect_to :index

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
