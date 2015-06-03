class BlogPost < ActiveRecord::Base

  has_and_belongs_to_many :categories, join_table:"blog_post_categories"

  validates_presence_of :title
  validates_presence_of :teaser
  validates_presence_of :summary
  validates_presence_of :published_at
  validates_presence_of :body

  manage_with_tolaria using: {
    icon: :file_o,
    category: "Syndication",
    permit_params: [
      :title,
      :teaser,
      :summary,
      :body,
      :published_at,
      :color,
      :portrait,
      :attachment,
      category_ids: []
    ],
  }

end
