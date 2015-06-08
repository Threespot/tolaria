Rails.application.routes.draw do
  Tolaria.draw_routes(self)
  root to:"homepage#homepage"
end
