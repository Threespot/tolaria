module Tolaria
  class ResourceController < TolariaController

    before_filter :load_managed_class!
    before_filter :strip_invalid_ransack_params!, only:[:index]

    # -------------------------------------------------------------------------
    # RESOURCE ACTIONS
    # -------------------------------------------------------------------------

    def index
      @resource = @managed_class.klass
      @search = @managed_class.klass.ransack(params[:q])
      @resources = @search.result.page(params[:page]).per(Tolaria.config.page_size)
      unless currently_sorting?
        @resources = @resources.order(@managed_class.default_order)
      end
      return render tolaria_template("index")
    end

    def show
      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      return render tolaria_template("show")
    end

    def new
      @resource = @managed_class.klass.new
      return render tolaria_template("new")
    end

    def create

      @resource = @managed_class.klass.new
      @resource.assign_attributes(resource_params[@managed_class.param_key])
      display_name = Tolaria.display_name(@resource)

      if @resource.save
        flash[:success] = "#{random_blingword} You created the #{@managed_class.model_name.human} “#{display_name}”."
        return redirect_to url_for([:admin, @managed_class.klass])
      else
        flash.now[:error] = "Your changes couldn’t be saved. Please correct the following errors:"
        return render tolaria_template("new")
      end

    end

    def edit
      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      return render tolaria_template("edit")
    end

    def update

      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      @resource.assign_attributes(resource_params[@managed_class.param_key])
      display_name = Tolaria.display_name(@resource)

      if @resource.save
        flash[:success] = "#{random_blingword} You updated the #{@managed_class.model_name.human.downcase} “#{display_name}”."
        return redirect_to url_for([:admin, @managed_class.klass])
      else
        flash.now[:error] = "Your changes couldn’t be saved. Please correct the following errors:"
        return render tolaria_template("update")
      end

    end

    def destroy

      @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
      display_name = Tolaria.display_name(@resource)

      begin
        @resource.destroy
      rescue ActiveRecord::DeleteRestrictionError => e
        flash[:restricted] = "You cannot delete “#{display_name}” because other items are using it."
        return redirect_to url_for([:admin, @managed_class.klass])
      end

      flash[:destructive] = "You deleted the #{@managed_class.model_name.human.downcase} “#{display_name}”."
      return redirect_to url_for([:admin, @managed_class.klass])

    end

    protected

    def random_blingword
      ["Done!", "Okay!", "Success!"].sample
    end

    def load_managed_class!
      Tolaria.managed_classes.each do |managed_class|
        if self.class.to_s == "Admin::#{managed_class.controller_name}"
          @managed_class = managed_class
          break
        end
      end
    end

    # Filters params, allows the default params Tolaria needs
    # and the configured `permitted_params` from the managed class
    def resource_params
      params.permit(
        *Tolaria.config.permitted_params,
        @managed_class.param_key => @managed_class.permitted_params
      )
    end

    # Some Ransack methods raise exceptions if the `q` param is invalid.
    # Strip `q` params not created by Ransack
    def strip_invalid_ransack_params!
      return true if params[:q].blank?
      unless params[:q].is_a?(Hash)
        params.delete(:q)
      end
    end

    # Returns true if there is a sorting parameter for Ransack
    def currently_sorting?
      params[:q].present? && params[:q][:s].present?
    end

  end
end
