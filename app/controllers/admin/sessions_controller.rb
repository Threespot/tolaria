class Admin::SessionsController < Tolaria::TolariaController

  skip_before_filter :authenticate_admin!

  # ---------------------------------------------------------------------------
  # NEW
  # Present the signin form
  # ---------------------------------------------------------------------------

  def new
    @greeting = random_greeting
    @admin = Administrator.new
    render "admin/session/form", layout:"admin/sessions"
  end

  # ---------------------------------------------------------------------------
  # CODE REQUEST
  # Dispatch an email with the admin’s passcode, or return JSON errors
  # ---------------------------------------------------------------------------

  def request_code

    @administrator = Administrator.find_by_email(params[:administrator][:email].downcase.strip)

    unless @administrator
      response.status = 404
      return render json: {
        status: response.status,
        error: "That email address couldn’t be found. Contact an existing site administrator if you need an account created for you.",
      }
    end

    if @administrator.locked?
      response.status = 423
      return render json: {
        status: response.status,
        error: %{
          Your account has made too many requests and has been locked.
          Please try again after #{Tolaria.config.lockout_duration/60} minutes.
        }.squish,
      }
    end

    passcode = @administrator.set_passcode!
    if PasscodeMailer.passcode(@administrator, passcode).deliver_now
      @administrator.accrue_strike!
      response.status = 204
      return render nothing: true
    else
      response.status = 500
      return render json: {
        status: response.status,
        error: "An email couldn’t be sent for you. Please try again later."
      }
    end

  end

  # ---------------------------------------------------------------------------
  # CREATE
  # Attempt to sign in the admin with the email/passocde combination.
  # ---------------------------------------------------------------------------

  def create
    @administrator = Administrator.find_by_email(params[:administrator][:email].downcase.strip)
    if @administrator and @administrator.authenticate(params[:administrator][:passcode])
      cookies.permanent[:auth_token] = @administrator.auth_token
      # TODO: redirect to the /admin path
      flash[:success] = "It worked!"
      return redirect_to admin_new_session_path
    else
      flash[:error] = "That passcode wasn’t correct. Please request a new passcode and try again."
      return redirect_to admin_new_session_path
    end
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
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
