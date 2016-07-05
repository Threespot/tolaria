class Footnote < ApplicationRecord
  belongs_to :blog_post
  validates_presence_of :description
  validates_presence_of :url
end
