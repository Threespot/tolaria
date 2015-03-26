class Admin::SessionsController < Tolaria::TolariaController

  def new
    @greeting = random_greeting
    @admin = Administrator.new
    render "admin/session/form", layout:"admin/sessions"
  end

  def request_code
    if administrator = Administrator.find_by_email(params[:email])
      if administrator.locked?
        # TODO: Better error message for locked accounts
        render json: { status: "error", :message => "account is locked!" }
      else
        passcode = administrator.set_passcode!
        if PasscodeMailer.passcode(administrator, passcode).deliver_now
          administrator.accrue_strike!
        else
          # TODO: Better error message for passcode sending failure
          render json: { status: "error", :message => "error sending passcode!" }
        end
        # TODO: Better message if we even need to report a message on finding an account
        render json: { status: "success", :message => "account found!" }
      end
    else
      # TODO: Better error message
      render json: { status: "error", :message => "no account found!" }
    end
  end

  def create
    administrator = Administrator.find_by_email(params[:administrator][:email])
    if administrator and administrator.authenticate(params[:administrator][:passcode])
      cookies.permanent[:auth_token] = administrator.auth_token
      # TODO: redirect to the /admin path
      redirect_to admin_new_session_path, flash: { success: "it works" }
    else
      redirect_to admin_new_session_path, flash: { error: "nope" }
    end
  end

  def destroy
    cookies.delete(:auth_token)
    # TODO: revise logout message
    redirect_to new_session_path, :flash => { success: 'You have successfully logged out.' }
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
