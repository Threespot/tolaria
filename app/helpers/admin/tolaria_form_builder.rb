class Admin::TolariaFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :render, to: :@template

  def hint(hint_text)
    content_tag(:p, hint_text.chomp, class:"hint")
  end

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

  def markdown_composer(method, options = {})
    render(partial:"admin/shared/forms/markdown_composer", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  def attachment_field(method, options = {})
    render(partial:"admin/shared/forms/attachment_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  def image_field(method, options = {})
    render(partial:"admin/shared/forms/image_field", locals: {
      f: self,
      method: method,
      options: options,
      preview_url: options[:preview_url]
    })
  end

  def timestamp_field(method, options = {})
    render(partial:"admin/shared/forms/timestamp_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

  def slug_field(method, options = {})
    pattern = options.delete(:pattern)
    render(partial:"admin/shared/forms/slug_field", locals: {
      f: self,
      method: method,
      options: options,
      pattern: (pattern || "/blog-example/*")
    })
  end

  def color_field(method, options = {})
    render(partial:"admin/shared/forms/color_field", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

end
