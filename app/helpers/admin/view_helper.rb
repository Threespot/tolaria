module Admin::ViewHelper

  def display_name_for(resource)
    Tolaria.config.display_name_methods.each do |method|
      if resource.respond_to? method
        return resource.send(method)
      end
    end
  end

  def status_tag(status)
    content_tag :span, class:"status-tag #{status.underscore.dasherize}" do
      status.to_s
    end
  end

  def monospace(content)
    content_tag :span, class:"monospace" do
      content
    end
  end

  def naked_link(uri)
    link_to uri, uri, class:"monospace"
  end

  def header_background_xpos
    691/30 * (Date.current.day - 1)
  end

end
