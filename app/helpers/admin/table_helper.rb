module Admin::TableHelper

  # Returns a `<table class="index-table">` tag with the appropriate wrapper
  # and the given +content+ or block content inside it.
  def index_table(content = nil, &block)
    content_tag :div, class:"index-table-wrap" do
      content_tag :table, class:"index-table" do
        content || yield
      end
    end
  end

  # Returns a `<table class="show-table">` tag with the given +content+
  # or block content inside it.
  def show_table(content = nil, &block)
    content_tag :table, class:"show-table" do
      content || yield
    end
  end

  # Returns the following `<tr>`, suitable for use in a `table.show-table`:
  #
  #     <tr>
  #       <th>Field</th>
  #       <th>Details</th>
  #     </tr>
  def show_thead_tr
    %{<tr><th>Field</th><th>Details</th></tr>}.html_safe
  end

  # Returns a `<tr>` with two `<td>`s suitable for use in a `table.show-table`.
  # The given +label+ is placed inside the first `<td>`, while the +value+
  # is placed in the second `<td>`. Options are forwarded to `content_tag`
  # for the *second* `<td>`.
  #
  # If +label+ is a symbol, it is assumed to be a method on a variable named
  # `@resource` in the current template, and the `<tr>` is constructed
  # automatically for you by converting the symbol to a human-readable label
  # and calling the named method on @resource to get the +value+.
  #
  # ==== Signatures
  #
  #     # Set the values yourself, and a class on the second `<td>`
  #     show_tr "Slug", resource.slug, class:"monospace"
  #
  #     # Attempt to auto-fill the row based on a method name
  #     show_tr :slug
  def show_tr(label, value = nil, options = nil)

    if label.is_a?(Symbol)
      options = value
      value = @resource.send(label)
      label = label.to_s.titleize
    end

    content = content_tag(:td, class:"show-td-field") do
      content_tag :span do
        label
      end
    end

    content << content_tag(:td, options) do
      value.to_s
    end

    content_tag(:tr) do
      content
    end

  end

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
  #    # Create a header that sorts a column, with custom label
  #    index_th("Strange Title", sort: :title)
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

    links = []

    if @managed_class.allows?(:edit)
      links << link_to("Edit", url_for(action:"edit", id:resource.id), class:"button -small")
    end

    if @managed_class.allows?(:show)
      links << link_to("Inspect", url_for(action:"show", id:resource.id), class:"button -small")
    end

    if @managed_class.allows?(:destroy)
      links << link_to("Delete", url_for(action:"destroy", id:resource.id), class: "button -small", method: :delete, :'data-confirm' => deletion_warning(resource))
    end

    return content_tag(:td, links.join("").html_safe, class:"actions-td")

  end

end
