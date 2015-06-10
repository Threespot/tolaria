class Image < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :attachment_address

  manage_with_tolaria using: {
    icon: :image,
    priority: 1,
    category: "Media",
    permit_params: [
      :title,
      :alternate_text,
      :credit,
      :keywords,
      :attachment_address,
    ],
  }

end
