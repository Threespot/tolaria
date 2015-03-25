module Tolaria

  # The developer calls `Tolaria.draw_routes(self)` inside the
  # router’s block scope

  def self.draw_routes(router)

    self.reload_app_folder!

    router.instance_exec(managed_classes) do |managed_classes|
      namespace :admin do

        # Create routes for the authentication/passcode flow
        get "signin", to:"sessions#new"
        post "signin/code", to:"sessions#send_code"
        post "signin", to:"sessions#create"
        delete "signout", to:"sessions#destroy"

        # Create routes for administrator management
        resources :administrators

        # Create routes for every managed class
        managed_classes.each do |managed_class|
          resources managed_class.model_name.route_key
        end

      end
    end

  end

end
