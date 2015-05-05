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

  # Attempt to automatically construct a default text search
  # field name for Ransack from a model's table settings
  def self.text_search_chain_for(model)
    textual_columns = model.columns_hash.select do |column, settings|
      settings.sql_type.include?("character") || settings.sql_type.include?("text")
    end
    return %{#{textual_columns.keys.join("_or_")}_cont}.to_sym
  end

  # Returns a deletion warning message for the given ActiveRecord instance
  def self.deletion_warning_for(resource)
    return %{Are you sure you want to delete the #{resource.model_name.human.downcase} “#{self.display_name(resource)}”? This action is not reversible.}
  end

end
