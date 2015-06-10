class Miscellany < ActiveRecord::Base

  manage_with_tolaria using:{
    icon: "cogs",
    category: "Settings",
    allowed_actions: [:index, :show, :edit],
    permit_params: [
      :value
    ],
  }

end
