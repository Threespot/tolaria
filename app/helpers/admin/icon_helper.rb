module Admin::IconHelper

  def awesome_icon(icon_name = :file_alt, transform: nil)
    css_class = "icon"
    if transform.present?
      class_class += transform.dasherize
    end
    content_tag :i, class:css_class do
      "&\#x#{Tolaria::FontAwesomeMap[icon_name]};".html_safe
    end
  end

end
