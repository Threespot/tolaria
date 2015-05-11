module Admin::TableHelper

  # Returns a `<th>` tag, suitable for use inside a `table.index-table`.
  # +field_or_label+ may be any string, or a symbol naming a model column.
  # +sort+ may be `true`, `false`, or a symbol. See the signtures below.
  #
  # If the column is sortable, the `<th>` will contain a Ransack sort link
  # that allows the end-user to organize the table by that column.
  #
  # ==== Signatures
  #
  #    # Create a header that sorts a named column
  #    index_th(:title, sort:true)
  #
  #    # Create a header that sorts column, with custom label
  #    index_th("Strange Title", sort:true)
  #
  #    # Create a header that can't be sorted
  #    index_th("Strange Title", sort:false)
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

  # Returns a `<td>` tag, suitable for use inside a `table.index-table`.
  # If +method_or_content+ is a symbol, it will call that method on the
  # given +resource+ to obtain the content of the `<td>`. Otherwise
  # it expects +method_or_content+ or a passed block to provide suitable string.
  #
  # #### Special Options
  #
  # - `:image` - A URL to a square image to use in the <td>, floating to the
  #   left of the content. The image should be a square at least
  #   14×14px in size.
  #
  # Other options are forwarded to `content_tag` for the `<td>`.
  def index_td(resource, method_or_content, options = {}, &block)

    options = method_or_content if block_given?

    if block_given?
      content = yield
    elsif method_or_content.is_a?(Symbol)
      content = resource.send(method_or_content)
    else
      content = method_or_content
    end

    options[:class] = "index-td #{options[:class]}"

    if image = options.delete(:image)
      image = image_tag(image, size:"18x18", alt:"")
    end

    return content_tag(:td, options) do
      link_to("#{image}#{content}".html_safe, url_for(action:"edit", id:resource.id))
    end

  end

  # Returns an `index_th` with label `"Actions"` that is not sortable.
  def actions_th
    index_th("Actions", sort:false)
  end

  # Returns a `<td>` tag, suitable for use inside a `table.index-table`.
  # The tag contains buttons to edit, inspect, and delete the given +resource+.
  def actions_td(resource)
    edit_link = link_to("Edit", url_for(action:"edit", id:resource.id), class:"button -small")
    inspect_link = link_to("Inspect", url_for(action:"show", id:resource.id), class:"button -small")
    delete_link = link_to("Delete", url_for(action:"show", id:resource.id), class: "button -small", method: :delete, :'data-confirm' => deletion_warning(resource))
    return content_tag(:td, "#{edit_link}#{inspect_link}#{delete_link}".html_safe, class:"actions-td")
  end

end
