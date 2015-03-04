module Admin::InternalHelper

  def tolaria_navigation_link(label, icon_name, index_path)
    css_class = index_path.in?(url_for) ? "current" : nil
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

  def index_th(label, sort:false)

    sorting_class = sort.present?? "-sortable" : "-unsortable"
    sort_direction = nil

    if label == :id
      label = "ID"
    elsif label.is_a?(Symbol)
      label = label.to_s.humanize.titleize
    end

    content_tag(:th, label, class:"#{sorting_class} #{sort_direction}")

  end

  def index_td(content, class:false)
    content_tag :td, content
  end

  def actions_th
    index_th("Actions", sort:false)
  end

end
