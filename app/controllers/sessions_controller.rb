class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:error] = "You're already logged in"
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Welcome back " + user.email + "!"
      redirect_to root_url
    else
      flash[:error] = "Failed"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
