Rails.application.routes.draw do
  root to:"homepage#homepage"
  Tolaria.draw_routes(self)
end
