class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_url
    end
    @errors = []
    @ref_path = params[:ref_path] || 'test'
  end

  def create
    user = User.find_by(email: session_params[:email])
    @errors = []
    unless user.nil?
      unless can_login?(user)
        flash[:danger] = 'You have been banned from the site.'
        logger.warn "Banned user ${email}: attempt to login." % {email: user.email}
        redirect_to root_url
        return
      end
      if user.authenticate(session_params[:password])
        log_in user
        if params[:ref_path]
          redirect_to params[:ref_path]
        else
          redirect_to root_url
        end
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
    if params[:ref_path]
      redirect_to params[:ref_path]
    else
      redirect_to root_url
    end
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end

end
