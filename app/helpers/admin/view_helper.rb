module Admin::ViewHelper

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
