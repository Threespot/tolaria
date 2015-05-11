module Tolaria

  # Using this method, you can attempt to get a pretty “display”
  # string for presenting the passed +resource+ as a label.
  def self.display_name(resource)
    Tolaria.config.display_name_methods.each do |method_name|
      if resource.respond_to?(method_name)
        return resource.send(method_name).to_s.truncate(40, omission:"…")
      end
    end
  end

end
