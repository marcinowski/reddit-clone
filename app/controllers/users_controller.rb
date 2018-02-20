class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    @posts = @user.posts.all
    @comments = @user.comments.order(:created_at)
  end

  def new
    @user = User.new
  end

  def update
  end

  def destroy
  end

  def create
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
