module Admin::InternalHelper

  # Returns a navigation menu link with the given label,
  # Font Awesome icon name, and URI
  def tolaria_navigation_link(label, icon_name, index_path)
    css_class = index_path.in?(url_for) ? "current" : nil
    link_to index_path, class:css_class do
      fontawesome_icon(icon_name) << " #{label}"
    end
  end

  # Returns an <i> tag that displays a Font Awesome icon
  def fontawesome_icon(icon_name = "", options = {})
    icon_name = icon_name.to_s.parameterize.gsub("_", "-")
    content_tag :i, nil, options.reverse_merge({
      :class => "icon icon-#{icon_name}",
      :"aria-hidden" => true,
    })
  end

  # Returns a URI to a Gravatar for the given email
  def gravatar_for(email)
    digest = Digest::MD5.hexdigest(email)
    return "https://secure.gravatar.com/avatar/#{digest}?d=retro&s=36"
  end

  # Returns true if a partial is available at "admin/#{template_path}"
  def admin_template_exisits?(template_path)
    lookup_context.template_exists?("admin/#{template_path}", [], true)
  end

  # Returns true if there are no records in the database for the current model
  def no_resources_exist?
    @managed_class.klass.count.eql?(0)
  end

  # True if Ransack filtering parameters are present
  def currently_filtering?
    params[:q].present? && params[:q].is_a?(Hash) && params[:q].keys.reject{|key| key == "s"}.any?
  end

  # Attempt to automatically construct a default text search
  # field name for Ransack from a given model's table settings
  def ransack_text_search_chain(model)
    textual_columns = model.columns_hash.select do |column, settings|
      settings.sql_type.include?("character") || settings.sql_type.include?("text")
    end
    textual_columns = ["id"] if textual_columns.none?
    return %{#{textual_columns.keys.join("_or_")}_cont}.to_sym
  end

  # Returns a deletion warning message for the given ActiveRecord instance
  def deletion_warning(resource)
    return %{Are you sure you want to delete the #{resource.model_name.human.downcase} “#{Tolaria.display_name(resource)}”? This action is not reversible.}
  end

end
