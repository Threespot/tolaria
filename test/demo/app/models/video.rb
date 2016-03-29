class Video < ApplicationRecord

  validates_presence_of :title
  validates_presence_of :youtube_id

  manage_with_tolaria using:{
    navigation_label: "YouTube Videos",
    icon: "youtube-play",
    category: "Media",
    permit_params: [
      :title,
      :youtube_id,
      :description,
    ],
  }

end
