class MarkdownInput < Formtastic::Inputs::TextInput
  def input_html_options
    super.merge(:class => "markdown")
  end
  def to_html
    controls = %{
      <div class="markdown-controls">
        <div class="markdown-formatting">
          <button class="markdown-button strong" title="Strong text">&#xf032;</button>
          <button class="markdown-button em" title="Emphasis">&#xf033;</button>
          <button class="markdown-button link" title="Add a Link">&#xf0c1;</button>
        </div>
        <div class="markdown-meta">
          <button class="markdown-button write">Write</button>
          <button class="markdown-button preview">Preview</button>
          <button class="markdown-button reference">Reference</button>
        </div>
      </div>
    }
    super.gsub("<textarea", "#{controls}<textarea").html_safe
  end
end
