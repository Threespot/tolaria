class BlogPost < ActiveRecord::Base

  has_and_belongs_to_many :topics, join_table:"blog_post_topics"
  has_many :footnotes
  accepts_nested_attributes_for :footnotes

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :published_at
  validates_presence_of :body

  manage_with_tolaria using: {
    icon: "pencil-square-o",
    priority: 1,
    default_order: "id DESC",
    category: "Prose",
    paginated: true,
    permit_params: [
      :title,
      :summary,
      :body,
      :published_at,
      :color,
      :portrait,
      :attachment,
      topic_ids: [],
      footnotes_attributes: [
        :_destroy,
        :id,
        :url,
        :description,
      ]
    ],
  }

  after_initialize :initalize_published_at!
  def initalize_published_at!
    self.published_at ||= Time.current
  rescue ActiveModel::MissingAttributeError
    # Swallow this exception
  end

end
