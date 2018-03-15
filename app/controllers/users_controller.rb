class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    @posts = @user.posts.all
    @comments = @user.comments.order(:created_at)
  end

  def new
    if logged_in?
      return redirect_to root_url
    end
    @user = User.new
  end

  def update
  end

  def destroy
  end

  def create
    if logged_in?
      return redirect_to root_path
    end
    user = User.new(user_params)
    if user.save
      log_in user
      flash[:success] = "Welcome to Reddit!"
      return redirect_to user_path(username: user.username)
    else
      @user = user
      return render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
