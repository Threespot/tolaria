class Topic < ApplicationRecord

  has_and_belongs_to_many :blog_posts, join_table:"blog_post_topics"

  validates_presence_of :label
  validates_presence_of :slug

  before_validation :set_slug!
  def set_slug!
    self.slug = self.label.parameterize if self.label.present?
  end

  manage_with_tolaria using:{
    icon: :leaf,
    category: "Prose",
    permit_params: [
      :label,
      :slug,
    ],
  }

end
