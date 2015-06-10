class Footnote < ActiveRecord::Base
  belongs_to :blog_post
  validates_presence_of :description
  validates_presence_of :url
end
