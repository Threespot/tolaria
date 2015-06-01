Rails.application.routes.draw do
  root to:"welcome#homepage"
  Tolaria.draw_routes(self)
end
