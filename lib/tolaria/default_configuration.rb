Tolaria.configure do |config|

  config.route_prefix = "admin"

  config.default_sort_order = "id DESC"

  config.interface_title = "Site Administration"

  config.markdown_header_delta = -1

  config.display_name_methods = %i[
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

end
