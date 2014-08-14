module Admin::InternalHelper

  def tolaria_navigation_link(label, icon, index_path)
    css_class = url_for.in?(index_path) ? "current" : nil
    link_to index_path, class:css_class do
      %{<i class="icon" aria-hidden="true">&#x#{Tolaria.font_awesome_map[icon]};</i> #{label}}.html_safe
    end
  end

end
