module Admin::InternalHelper

  def tolaria_navigation_link(label, icon_name, index_path)
    css_class = url_for.in?(index_path) ? "current" : nil
    link_to index_path, class:css_class do
      fontawesome_icon(icon_name) << " #{label}"
    end
  end

  def fontawesome_icon(icon_name = "")
    icon_name = icon_name.to_s.parameterize.gsub("_", "-")
    content_tag :i, "", {
      :class => "icon icon-#{icon_name}",
      :"aria-hidden" => true,
    }
  end

  def hint(hint_text)
    return content_tag(:p, hint_text, class:"hint")
  end

end
