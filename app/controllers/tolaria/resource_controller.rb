class Tolaria::ResourceController < Tolaria::TolariaController

  before_action :load_managed_class!

  def index
    @search = @managed_class.klass.ransack(ransack_params)
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
    if managed_class.allows?(:index) && params[:save_and_review].blank?
      url_for(action:"index", q:ransack_params)
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

  # Logs all validation errors for the current resource to the Rails console
  def log_validation_errors!
    unless Rails.env.test?
      puts "#{@resource.class} failed validation and was not saved:"
      @resource.errors.full_messages.each do |message|
        puts "  #{message}"
      end
    end
  end

  # Returns params[:q] as a hash if it can be converted.
  # Ransack expects this generic hash and has its own internal
  # logic for handing the many possible keys of the hash.
  def ransack_params
    if params[:q].present? && params[:q].respond_to?(:permit!)
      return params[:q].to_unsafe_hash
    else
      return nil
    end
  end

  # True if there is a sorting parameter for Ransack
  def currently_sorting?
    ransack_params.present? && ransack_params[:s].present?
  end

  # True if there are filtering parameters for Ransack
  def currently_filtering?
    if currently_sorting?
      ransack_params.keys.many?
    else
      ransack_params.present? && ransack_params.keys.any?
    end
  end

  helper_method :ransack_params
  helper_method :currently_sorting?
  helper_method :currently_filtering?

end
