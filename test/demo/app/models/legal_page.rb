class LegalPage < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :slug

  manage_with_tolaria using: {
    icon: "gavel",
    priority: 100,
    category: "Prose",
    permit_params: [
      :title,
      :slug,
      :summary,
      :body
    ],
  }

  before_validation :set_slug!
  def set_slug!
    self.slug = self.slug.parameterize if self.slug.present?
  end

end
