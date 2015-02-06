module Tolaria

  def self.draw_routes(router)

    self.reload_app_folder!

    router.instance_exec(managed_classes) do |managed_classes|
      namespace Tolaria.config.route_prefix.to_sym do
        managed_classes.each do |klass|
          resources klass.to_sym, controller:klass.to_sym
        end
      end
    end

  end

end
