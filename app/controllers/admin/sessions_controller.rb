class Admin::SessionsController < Tolaria::TolariaController

  skip_before_filter :authenticate_admin!

  # Present the signin form

  def new
    if current_administrator
      return redirect_to(Tolaria.config.default_redirect, status:303)
    end
    @greeting = random_greeting
    @admin = Administrator.new
    return render "admin/session/form", layout:"admin/sessions"
  end

  # Code request: Dispatch an email with the admin’s passcode, or return JSON errors

  def request_code

    email = params[:administrator].try(:[], :email).to_s.downcase.chomp
    @administrator = Administrator.find_by_email(email)

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

    if @administrator.send_passcode_email!
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

  # Create: Attempt to sign in the admin with the email/passcode combination.

  def create

    email = params[:administrator].try(:[], :email).to_s.downcase.chomp
    passcode = params[:administrator].try(:[], :passcode).to_s

    @administrator = Administrator.find_by_email(email)

    if @administrator && @administrator.authenticate!(passcode)

      # Auth successful
      # Set an signed admin cookie with our auth_token
      cookies.encrypted[:admin_auth_token] = {
        value: @administrator.auth_token,
        expires: params[:remember_me].eql?("1") ? 1.year.from_now : nil,
        secure: Rails.env.production?, # Expect a TLS connection in production
        httponly: true, # JavaScript should not read this cookie
      }

      # Redirect to the admin pane
      return redirect_to(Tolaria.config.default_redirect, status:303)

    else

      # Auth failed
      flash[:error] = "That passcode wasn’t correct. Please request a new passcode and try again."
      return redirect_to(admin_new_session_path, status:303)

    end

  end

  # Destroy: Sign out the admin and reset the session

  def destroy
    cookies.delete(:admin_auth_token)
    reset_session
    flash[:success] = "You have successfully signed out."
    return redirect_to(admin_new_session_path, status:303)
  end

  protected

  # Returns a random UI greeting.
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
