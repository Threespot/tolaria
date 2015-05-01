module Tolaria

  # Using this method, you can attempt to get a pretty “display”
  # string for presenting a model instance as a label
  def self.display_name(resource)
    Tolaria.config.display_name_methods.each do |method_name|
      if resource.respond_to?(method_name)
        return resource.send(method_name).to_s.truncate(40, omission:"…")
      end
    end
  end

  def self.text_search_chain_for(model)
    textual_columns = model.columns_hash.select do |column, settings|
      settings.sql_type.include?("character") || settings.sql_type.include?("text")
    end
    return %{#{textual_columns.keys.join("_or_")}_cont}.to_sym
  end

end
