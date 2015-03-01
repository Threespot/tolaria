module Tolaria

  def self.draw_routes(router)

    self.reload_app_folder!

    router.instance_exec(managed_classes) do |managed_classes|
      namespace :admin do
        managed_classes.each do |managed_class|
          resources managed_class.model_name.route_key
        end
      end
    end

  end

end
