module Admin::ViewHelper

  ADMIN_PILL_COLORS = HashWithIndifferentAccess.new({
    green: "3BAB46",
    red: "DA3946",
    blue: "3497BE",
    black: "343242",
    grey: "777777",
  })

  # Returns a navigation menu link with the given label,
  # Font Awesome icon name, and URI
  def tolaria_navigation_link(label, icon, index_path, options = {})
    options[:class] = "#{options[:class]} current" if index_path.in?(url_for)
    link_to index_path, options do
      fontawesome_icon(icon) << " #{label}"
    end
  end

  # Returns an `<i>` tag that displays the Font Awesome icon for the given `icon`.
  # Names much match those from [the Font Awesome site](http://fontawesome.io/icons/).
  def fontawesome_icon(icon = "", options = {})
    icon = icon.to_s.parameterize.tr("_", "-")
    content_tag :i, nil, options.reverse_merge({
      :class => "icon icon-#{icon}",
      :"aria-hidden" => true,
    })
  end

  # Returns a URI to a Gravatar for the given email
  def gravatar_for(email)
    digest = Digest::MD5.hexdigest(email)
    return "https://secure.gravatar.com/avatar/#{digest}?d=retro&s=36"
  end

  # Returns true if a partial is available at `"admin/#{template_path}"`
  def admin_template_exists?(template_path)
    lookup_context.template_exists?("admin/#{template_path}", [], true)
  end

  # True if Ransack filtering parameters are present
  def currently_filtering?
    params[:q].present? && params[:q].is_a?(Hash) && params[:q].keys.reject{|key| key == "s"}.any?
  end

  # Attempt to automatically construct a default text search
  # field name for Ransack from a given model's table settings
  def ransack_text_search_chain(model)
    textual_columns = model.columns_hash.select do |column, settings|
      settings.sql_type.include?("char") || settings.sql_type.include?("text")
    end
    textual_columns = {id:"id"} if textual_columns.none?
    return %{#{textual_columns.keys.join("_or_")}_cont}.to_sym
  end

  # Returns a deletion warning message for the given ActiveRecord instance
  def deletion_warning(resource)
    return %{Are you sure you want to delete the #{resource.model_name.human.downcase} “#{Tolaria.display_name(resource)}”? This action is not reversible.}
  end

  # Returns a `<span>` tag that displays the given `label` as a pill
  # status badge. You can change the color of the pill by providing a
  # six-digit hexadecimal `color` string, or passing one of the predefined
  # color names: `:green`, `:red`, `:blue`, `:black`, `:grey`.
  def pill(label, color: :black)

    if ADMIN_PILL_COLORS[color].present?
      color = ADMIN_PILL_COLORS[color]
    else
      color = color.to_s.delete("#")
    end

    content_tag :span, label.to_s, class:"pill", style:"background-color:##{color}"

  end

end
