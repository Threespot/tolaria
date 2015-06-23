module Tolaria

  # Contains a workflow for rendering Markdown.
  # If no renderer has been configured, defers to `simple_format`.
  class MarkdownRendererProxy

    include ::ActionView::Helpers::TextHelper

    # Calls the configured Markdown renderer, if none exists
    # then uses `simple_format` to return more than nothing.
    def render(document)
      if Tolaria.config.markdown_renderer.nil?
        return simple_format(document)
      else
        @markdown_renderer ||= Tolaria.config.markdown_renderer.constantize
        return @markdown_renderer.render(document)
      end
    end

  end

  # Calls the configured Markdown renderer
  def self.render_markdown(document)
    @markdown_renderer ||= Tolaria::MarkdownRendererProxy.new
    return @markdown_renderer.render(document)
  end

end
