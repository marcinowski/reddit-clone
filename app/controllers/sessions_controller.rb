class SessionsController < ApplicationController
  layout "auth"
  def new
    if logged_in?
      redirect_to root_url
    end
    @errors = []
  end

  def create
    user = User.find_by(email: session_params[:email])
    @errors = []
    if user
      if user.authenticate(session_params[:password])
        log_in user
        redirect_to root_url
      else
        @errors.push("Incorrect password! Please try again.")
        render "new"
      end
    else
      @errors.push("User's email %{email} not found." % {email: session_params[:email]})
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end

end
