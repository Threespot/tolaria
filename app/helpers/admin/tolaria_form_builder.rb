class Admin::TolariaFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :render, to: :@template

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
      download_url: "https://d13yacurqjgara.cloudfront.net/users/48702/screenshots/1509857/url_1x.png"
    })
  end

end