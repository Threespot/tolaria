module Tolaria

  # Using this method, you can attempt to get a pretty “display”
  # string for presenting a model instance as a label
  def self.display_name(resource)
    Tolaria.config.display_name_methods.each do |method_name|
      if resource.respond_to?(method_name)
        return resource.call(method_name).to_s.truncate(40, omission:"…")
      end
    end
  end

end
