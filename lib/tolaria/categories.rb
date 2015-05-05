module Tolaria

  def self.categories
    (self.config.menu_categories + self.managed_classes.collect(&:category)).uniq
  end

end
