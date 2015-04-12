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

    content_tag(:th, label, class:"index-th #{sorting_class} #{sort_direction}")

  end

  def index_td(resource, method_or_content, options = {})

    if method_or_content.is_a?(Symbol)
      content = resource.send(method_or_content)
    else
      content = method_or_content
    end

    options[:class] = "index-td #{options[:class]}"

    return content_tag(:td, options) do
      link_to url_for(action:"edit", id:resource.id) do
        content.to_s
      end
    end

  end

  def actions_th
    index_th("Actions", sort:false)
  end

  def actions_td(resource)
    content_tag :td, class:"actions-td" do
      link_to("Edit", url_for(action:"edit", id:resource.id), class:"button -small") <<
      link_to("Inspect", url_for(action:"show", id:resource.id), class:"button -small") <<
      link_to("Delete", url_for(action:"show", id:resource.id), class:"button -small", method: :delete)
    end
  end

end
