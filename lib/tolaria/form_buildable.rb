module Tolaria
  module FormBuildable

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

    # Creates a `searchable_select` that also shows a dynamic image preview of the selected record.
    # Useful for previewing images or avatars chosen by name.
    # +preview_url_method+ should be a method name to call on the associated model instance
    # that returns a fully-qualified URL to the image preview.
    def image_association_select(method, collection, value_method, text_method, preview_url_method, options = {})
      render(partial:"admin/shared/forms/image_association_select", locals: {
        f: self,
        method: method,
        collection: collection,
        value_method: value_method,
        text_method: text_method,
        preview_url_method: preview_url_method,
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
    # - `:preview_url` If the file already exists, provide a URL to a 42×42px
    #   version of the image, and it will be displayed to the user in a preview
    #   box to better communicate which file they are replacing.
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
    def swatch_field(method, options = {})
      render(partial:"admin/shared/forms/swatch_field", locals: {
        f: self,
        method: method,
        options: options,
      })
    end

    # Opens an ERB block to manage an accepts_nested_attributes_for association
    # in the current form. The block will look similar to this:
    #
    #    <%= f.nested_fields_for :footnotes do |ff| %>
    #      <%= ff.nested_fields_header allow_destroy:true %>
    #      <% # Your nested model fields for footnote here %>
    #    <% end %>
    #
    # You must use `f.nested_fields_header` inside the block to create headers.
    #
    # If +allow_create+ is `false` then the button to append a new model
    # instance will be disabled. The default is `true`.
    def nested_fields_for(association, allow_create:true, &block)

      new_object = self.object.send(association).klass.new

      view_template = self.fields_for(association, new_object, child_index:new_object.object_id) do |builder|
        yield(builder)
      end

      existing_fields = self.fields_for(association) do |builder|
        yield(builder)
      end

      render(partial:"admin/shared/forms/nested_fields", locals: {
        association: association,
        button_label: association.to_s.humanize.singularize.titleize,
        new_object: new_object,
        existing_fields: existing_fields,
        allow_create: allow_create,
        f: self,
        data: {
          template: view_template.tr("\n"," "),
          id: new_object.object_id,
        }
      })

    end

    # Creates a header suitable for use inside `nested_fields_for` for separating
    # form elements. If +allow_destroy+ is `true`, controls will be exposed that allow
    # removing nested instances of the model. The default is `false`.
    def nested_fields_header(allow_destroy:false)
      render(partial:"admin/shared/forms/nested_fields_header", locals: {
        allow_destroy: allow_destroy,
        f: self,
      })
    end

  end
end

class Admin::FormBuilder < ActionView::Helpers::FormBuilder
  include Tolaria::FormBuildable
  delegate :content_tag, :tag, :render, to: :@template
end

class Ransack::Helpers::FormBuilder
  include Tolaria::FormBuildable
  delegate :content_tag, :tag, :render, to: :@template
end
