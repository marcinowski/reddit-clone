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
    if user.nil?
      @errors = ["User's email #{session_params[:email]} not found."]
      return render "new"
    end
    if user.authenticate(session_params[:password])
      if UserPermissions.can_login?(user)
        log_in user
        return params[:ref_path].nil? ? redirect_to(root_url) : redirect_to(params[:ref_path])
      else
        flash[:danger] = 'You have been banned from the site.'
        logger.debug "Banned user #{user.email}: attempt to login."
        return head(:forbidden)
      end
    else
      @errors = ["Incorrect password! Please try again."]
      @ref_path = params[:ref_path]
      return render "new"
    end
  end

  def destroy
    log_out
    return params[:ref_path].nil? ? redirect_to(root_url) : redirect_to(params[:ref_path])
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
