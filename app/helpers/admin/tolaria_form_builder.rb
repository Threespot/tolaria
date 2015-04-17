class Admin::TolariaFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :render, to: :@template

  def markdown_composer(method, options = {})
    render(partial:"admin/shared/forms/markdown_composer", locals: {
      f: self,
      method: method,
      options: options,
    })
  end

end
