module Tolaria

  # Returns the developer-configured categories for constructing
  # the nav menu, in addition to any unexpected categories from
  # configured managed classes.
  def self.categories
    (self.config.menu_categories + self.managed_classes.collect(&:category)).uniq
  end

  # Returns all of the managed classes for the given +category+,
  # sorted by their priority
  def self.classes_for_category(category)
    classes = Tolaria.managed_classes.select do |managed_class|
      managed_class.category == category
    end
    classes.sort_by do |klass|
      [klass.priority, klass.model_name.human]
    end
  end

end
