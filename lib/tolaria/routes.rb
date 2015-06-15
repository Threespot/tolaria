module Tolaria

  # The developer calls `Tolaria.draw_routes(self)` inside the
  # router’s scope. Tolaria automatically adds routes for managed classes.
  def self.draw_routes(router)

    self.reload!

    router.instance_exec(managed_classes) do |managed_classes|
      namespace :admin do

        # Create routes for AdminController
        root to:"admin#root", as:"root"
        get "help/:slug", to:"admin#help_link", as:"help_link"
        post "api/markdown", to:"admin#markdown"

        # Create routes for the authentication/passcode flow
        get "signin", to:"sessions#new", as:"new_session"
        post "signin/code", to:"sessions#request_code"
        post "signin", to:"sessions#create"
        delete "signout", to:"sessions#destroy", as:"destroy_session"

        # Create routes for every managed class
        managed_classes.each do |managed_class|
          resources managed_class.plural, only:managed_class.allowed_actions
        end

      end
    end

  end

end
