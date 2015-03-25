class Admin::SessionsController < Tolaria::TolariaController

  def new
    @greeting = random_greeting
    @admin = Administrator.new
    render "admin/session/form", layout:"admin/sessions"
  end

  def request_code
  end

  def create
  end

  def destroy
  end

  protected

  def random_greeting
    case [1,2,3].sample
    when 1
      return "Have we met before?"
    when 2
      return "Happy #{Date.current.strftime('%A')}!"
    when 3
      return "Hey there! Welcome back."
    end
  end

end
