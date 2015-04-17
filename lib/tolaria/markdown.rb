module Tolaria

  # A class to contain a workflow for rendering Markdown.
  # If no renderer has been configured, defer to simple_format.

  class MarkdownRendererProxy

    include ::ActionView::Helpers::TextHelper

    def render(document)
      if Tolaria.config.markdown_renderer.nil?
        return simple_format(document)
      else
        @markdown_renderer ||= Tolaria.config.markdown_renderer.constantize
        return @markdown_renderer.render(document)
      end
    end

  end

  def self.render_markdown(document)
    @markdown_renderer ||= Tolaria::MarkdownRendererProxy.new
    return @markdown_renderer.render(document)
  end

end
