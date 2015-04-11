module Tolaria

  # The developer calls `Tolaria.draw_routes(self)` inside the
  # router’s block scope

  def self.draw_routes(router)

    self.reload_app_folder!

    router.instance_exec(managed_classes) do |managed_classes|
      namespace :admin do

        root to:"admin#root", as:"root"

        # Create routes for the authentication/passcode flow
        get "signin", to:"sessions#new", as:"new_session"
        post "signin/code", to:"sessions#request_code"
        post "signin", to:"sessions#create"
        delete "signout", to:"sessions#destroy", as:"destroy_session"

        # Create routes for administrator management
        resources :administrators

        # Create routes for every managed class
        managed_classes.each do |managed_class|
          resources managed_class.model_name.route_key, only:managed_class.allowed_actions
        end

      end
    end

  end

end
