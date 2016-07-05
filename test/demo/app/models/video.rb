class Video < ApplicationRecord

  validates_presence_of :title
  validates_presence_of :youtube_id

  manage_with_tolaria using:{
    icon: "youtube-play",
    category: "Media",
    permit_params: [
      :title,
      :yotube_id,
      :description,
    ],
  }

end
