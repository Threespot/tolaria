Tolaria.configure do |config|

  config.route_prefix = "admin"

  config.default_sort_order = "id DESC"

  config.company_name = "Company Name"

  config.interface_title = "Content Admin"

  config.markdown_header_delta = -1

  config.display_name_methods = %i[
    admin_name
    display_name
    full_name
    pretty_name
    title
    name
    label
    username
    login
    email
    to_s
    id
  ]

  config.markdown_options = {
    autolink: true,                       # Automatically wrap naked links in <a>
    disable_indented_code_blocks: false,  # Don't disable code blocks
    fenced_code_blocks: true,             # Allow ``` code blocks (like GitHub)
    filter_html: true,                    # Don't allow any HTML, require shortcodes instead
    footnotes: false,                     # Disable footnotes
    hard_wrap: false,                     # Don't make <br> inside paragraphs with newlines
    highlight: false,                     # This is really ugly and missued
    lax_spacing: true,                    # Allow lazing spacing for lists
    link_attributes: {},                  # Don't add extra stuff to links (like rel=nofollow)
    no_images: false,                     # Allow images
    no_intra_emphasis: true,              # Handle _stuff*like*this_
    no_links: false,                      # Allow links
    no_styles: true,                      # Don't make any <style> tags
    prettify: false,                      # Don't use google-code-prettify
    quote: false,                         # Don't turn quotes into <q> tags
    safe_links_only: true,                # Only allow HTTP/S links, not FTP or SMB, etc
    space_after_headers: true,            # Force space between headers and hash marks
    strikethrough: true,                  # Allow ~~striked text~~
    superscript: true,                    # Allow super^(script)
    tables: false,                        # Tables only if we style and allow for it
    underline: false,                     # This is really ugly and missued
    with_toc_data: false,                 # Don't print a table of contents
    xhtml: false,                         # Output HTML5 instead of XML
  }

end
