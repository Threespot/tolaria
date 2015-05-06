module Admin::TableHelper

  def index_th(field_or_label, sort:true)

    case field_or_label
    when :id
      display_label = "ID"
    when Symbol
      display_label = field_or_label.to_s.humanize.titleize
    else
      display_label = field_or_label
    end

    if sort.is_a?(Symbol)
      return content_tag(:th, sort_link(@search, sort, display_label), class:"index-th")
    end

    if sort.eql?(true) && field_or_label.is_a?(Symbol)
      return content_tag(:th, sort_link(@search, field_or_label, display_label), class:"index-th")
    end

    return content_tag(:th, display_label, class:"index-th")

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

    edit_link = link_to("Edit", url_for(action:"edit", id:resource.id), class:"button -small")

    inspect_link = link_to("Inspect", url_for(action:"show", id:resource.id), class:"button -small")

    delete_link = link_to("Delete", url_for(action:"show", id:resource.id), {
      class: "button -small",
      method: :delete,
      :'data-confirm' => deletion_warning(resource),
    })

    return content_tag(:td, "#{edit_link}#{inspect_link}#{delete_link}".html_safe, class:"actions-td")

  end

end
