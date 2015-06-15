Tolaria.configure do |config|

  config.help_links << {
    title: "Markdown Help",
    slug: "markdown-help",
    markdown_file: "#{Rails.root}/app/views/admin/help/markdown-help.md"
  }

  config.markdown_renderer = "Rails::Markdown"

  config.menu_categories = [
    "Prose",
    "Media",
    "Settings",
  ]

end
