class Admin::AdminController < Tolaria::TolariaController

  def root
    redirect_to(Tolaria.config.default_redirect, status:303)
  end

end
