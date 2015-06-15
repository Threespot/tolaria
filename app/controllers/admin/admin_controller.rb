class Admin::AdminController < Tolaria::TolariaController

  skip_before_filter :authenticate_admin!, only:[:markdown]

  def root
    redirect_to(Tolaria.config.default_redirect, status:303)
  end

  def markdown
    return render(nothing:true, status:404) unless current_administrator.present?
    return render(inline:Tolaria.render_markdown(request.raw_post))
  end

  def help_link
    @help_link = Tolaria.help_links.find do |help_link|
      help_link.slug == params[:slug]
    end or raise ActiveRecord::RecordNotFound
    return render tolaria_template("help/help_link")
  end

end
