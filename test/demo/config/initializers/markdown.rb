require "redcarpet"

module Rails::Markdown

  # For details on these options see https://github.com/vmg/redcarpet
  MARKDOWN_OPTIONS = {
    autolink: true,
    disable_indented_code_blocks: false,
    fenced_code_blocks: true,
    filter_html: nil, # Allow raw HTML
    footnotes: false,
    hard_wrap: false,
    highlight: false, # Really ugly and misused
    lax_spacing: true,
    link_attributes: {},
    no_images: false,
    no_intra_emphasis: true,
    no_links: false,
    no_styles: true, # Don't make any <style> tags
    prettify: false, # Support for google-code-prettify
    quote: false,
    safe_links_only: true, # Only allow HTTP/S links, not FTP or SMB, etc
    space_after_headers: true,
    strikethrough: true,
    superscript: true,
    tables: false, # Tables only if we style and allow for it
    underline: false, # This is really ugly and misused
    with_toc_data: false,
    xhtml: false, # Output HTML5 instead
  }

  class HTMLRendererWithPants < ::Redcarpet::Render::HTML
    # Smarten quotes and typography
    include Redcarpet::Render::SmartyPants
  end

  # Given a markdown document, run it through our Markdown system
  def self.render(markdown_document)
    @options ||= MARKDOWN_OPTIONS
    @redcarpet ||= ::Redcarpet::Markdown.new(HTMLRendererWithPants.new(@options), @options)
    @redcarpet.render(markdown_document).html_safe
  end

end
