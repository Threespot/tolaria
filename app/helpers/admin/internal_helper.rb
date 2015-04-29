module Admin::InternalHelper

  def tolaria_navigation_link(label, icon_name, index_path)
    css_class = index_path.in?(url_for) ? "current" : nil
    link_to index_path, class:css_class do
      fontawesome_icon(icon_name) << " #{label}"
    end
  end

  def fontawesome_icon(icon_name = "", options = {})
    icon_name = icon_name.to_s.parameterize.gsub("_", "-")
    content_tag :i, nil, options.reverse_merge({
      :class => "icon icon-#{icon_name}",
      :"aria-hidden" => true,
    })
  end

  def gravatar_for(email:)
    digest = Digest::MD5.hexdigest(email)
    return "https://secure.gravatar.com/avatar/#{digest}?d=retro&s=36"
  end

  def admin_template_exisits?(template_path)
    lookup_context.template_exists?("admin/#{template_path}", [], true)
  end

end
