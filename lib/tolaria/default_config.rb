Tolaria.configure do |config|

  config.route_prefix = "admin"

  config.default_sort_order = "id DESC"

  config.company_name = "Client Site"

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

end
