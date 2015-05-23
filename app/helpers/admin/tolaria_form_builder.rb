class Admin::TolariaFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :render, to: :@template

  # Returns a `p.hint` used to explain a nearby form field containing
  # the given +hint_text+.
  def hint(hint_text)
    content_tag(:p, content_tag(:span, hint_text.chomp), class:"hint")
  end

  # Creates a `<select>` list that can be filtered by typing word fragments.
  # Uses the jQuery Chosen plugin internally to power the user interface.
  # Parameters are the same as Rails’s `collection_select`.
  #
  # #### Special Options
  #
  # - `:multiple` - if set to `true`, the select allows more than one choice.
  #   The default is `false`.
  def searchable_select(method, collection, value_method, text_method, options = {})
    render(partial:"admin/shared/forms/searchable_select", locals: {
      f: self,
      method: method,
      collection: collection,
      value_method: value_method,
      text_method: text_method,
      options: options,
      html_options: options,
    })
  end

  # Renders a Markdown composer element for editing +method+,
  # with fullscreen previewing and some text assistance tools.
  # Requires that you set `Tolaria.config.markdown_renderer`.
  # Options are forwarded to `text_area`.
  def markdown_composer(method, options = {})
    render(partial:"admin/shared/forms/markdown_composer", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  # Returns a file upload field with a more pleasant interface than browser
  # file inputs. Changes messaging if the +method+ already exists.
  # Options are forwarded to the hidden `file_field`.
  def attachment_field(method, options = {})
    render(partial:"admin/shared/forms/attachment_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  # Returns an image upload field with a more pleasant interface than browser
  # file inputs. Changes messaging if the +method+ already exists.
  #
  # #### Special Options
  #
  # - `:preview_url` If the image already exists, provide a URL to a 42×42px
  #   version of the image, and it will be show as a preview of the file the
  #   user will be replacing.
  #
  # Other options are forwarded to the hidden `file_field`.
  def image_field(method, options = {})
    render(partial:"admin/shared/forms/image_field", locals: {
      f: self,
      method: method,
      options: options,
      preview_url: options[:preview_url]
    })
  end

  # Returns a text field that allows the user to input a date and time.
  # Automatically validates itself and recovers to a template if blanked out.
  # This field uses moment.js to parse the date and set the values on a
  # set of hidden Rails `datetime_select` fields.
  # Options are forwarded to the hidden `datetime_select` group.
  def timestamp_field(method, options = {})
    render(partial:"admin/shared/forms/timestamp_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  # Returns a text field that parameterizes its input as users type
  # and renders it into the given preview template. Useful for
  # demonstrating the value of a URL or other sluggified text.
  #
  # #### Special Options
  #
  # - `:pattern` - Should be a string that includes an asterisk (`*`)
  #   character. As the user types, the asterisk will be replaced with
  #   a parameterized version of the text in the text box and shown
  #   in a preview area below the field.
  #   The default is `"/blog-example/*"`.
  #
  # Other options are forwarded to `text_field`.
  def slug_field(method, options = {})
    pattern = options.delete(:pattern)
    preview_value = self.object.send(method).try(:parameterize).presence || "*"
    render(partial:"admin/shared/forms/slug_field", locals: {
      f: self,
      method: method,
      options: options,
      preview_value: preview_value,
      pattern: (pattern || "/blog-example/*")
    })
  end

  # Returns a text field that expects to be given a 3 or 6-digit
  # hexadecimal color value. A preview block near the field
  # demonstrates the provided color to the user.
  # Options are forwarded to `text_field`.
  def color_field(method, options = {})
    render(partial:"admin/shared/forms/color_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

end
