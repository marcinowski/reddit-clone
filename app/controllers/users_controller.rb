class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    @posts = @user.posts.all
    @comments = @user.comments.order(:created_at)
  end

  def new
    if logged_in?
      redirect_to root_url
      return
    end
    @user = User.new
  end

  def update
  end

  def destroy
  end

  def create
    if logged_in?
      redirect_to root_url
      return
    end
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Reddit!"
      log_in @user
      redirect_to user_path(username: @user.username)
    else
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
