class Miscellany < ApplicationRecord

  manage_with_tolaria using:{
    icon: "cogs",
    category: "Settings",
    allowed_actions: [:index, :edit, :update],
    permit_params: [
      :value
    ],
  }

  def to_s
    key
  end

end
