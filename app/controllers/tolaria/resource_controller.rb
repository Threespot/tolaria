class Tolaria::ResourceController < Tolaria::TolariaController

  before_filter :load_managed_class!
  before_filter :strip_invalid_ransack_params!, only:[:index]

  def index
    @search = @managed_class.klass.ransack(params[:q])
    @resources = @search.result
    if @managed_class.paginated?
      @resources = @resources.page(params[:page]).per(Tolaria.config.page_size)
    end
    unless currently_sorting?
      @resources = @resources.order(@managed_class.default_order)
    end
    return render tolaria_template("tolaria_resource/index")
  end

  def show
    @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    return render tolaria_template("tolaria_resource/show")
  end

  def new
    @resource = @managed_class.klass.new
    return render tolaria_template("tolaria_resource/new")
  end

  def create

    @resource = @managed_class.klass.new
    @resource.assign_attributes(resource_params[@managed_class.param_key])
    display_name = Tolaria.display_name(@resource)

    if @resource.save
      flash[:success] = "#{random_blingword} You created the #{@managed_class.model_name.human} “#{display_name}”."
      return redirect_to form_completion_redirect_path(@managed_class, @resource)
    else
      log_validation_errors!
      flash.now[:error] = "Your changes couldn’t be saved. Please correct the following errors:"
      return render tolaria_template("tolaria_resource/new")
    end

  end

  def edit
    @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    return render tolaria_template("tolaria_resource/edit")
  end

  def update

    @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    @resource.assign_attributes(resource_params[@managed_class.param_key])
    display_name = Tolaria.display_name(@resource)

    if @resource.save
      flash[:success] = "#{random_blingword} You updated the #{@managed_class.model_name.human.downcase} “#{display_name}”."
      return redirect_to form_completion_redirect_path(@managed_class, @resource)
    else
      log_validation_errors!
      flash.now[:error] = "Your changes couldn’t be saved. Please correct the following errors:"
      return render tolaria_template("tolaria_resource/edit")
    end

  end

  def destroy

    @resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    display_name = Tolaria.display_name(@resource)

    begin
      @resource.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:restricted] = "You cannot delete “#{display_name}” because other items are using it."
      return redirect_to form_completion_redirect_path(@managed_class, @resource)
    end

    flash[:destructive] = "You deleted the #{@managed_class.model_name.human.downcase} “#{display_name}”."
    return redirect_to form_completion_redirect_path(@managed_class)

  end

  protected

  # Returns a random positive expression for use in
  # flash messages
  def random_blingword
    ["Done!", "Okay!", "Success!"].sample
  end

  # Returns a path we should redirect to when the form is completed successfully.
  # Handles route forbidding cases.
  def form_completion_redirect_path(managed_class, resource = nil)
    if managed_class.allows? :index
      url_for([:admin, managed_class.klass])
    elsif managed_class.allows?(:show) && resource.present?
      url_for(action:"show", id:resource.id)
    elsif managed_class.allows?(:edit) && resource.present?
      url_for(action:"edit", id:resource.id)
    else
      Tolaria.config.defaut_redirect
    end
  end

  # Load the Tolaria managed class for this controller
  def load_managed_class!
    @managed_class ||= Tolaria.managed_classes.find do |managed_class|
      self.class.to_s == "Admin::#{managed_class.controller_name}"
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

  # Logs all validation errors for the current resource to the Rails console
  def log_validation_errors!
    unless Rails.env.test?
      puts "#{@resource.class} failed validation and was not saved:"
      @resource.errors.full_messages.each do |message|
        puts "  #{message}"
      end
    end
  end

end
