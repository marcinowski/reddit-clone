class UsersController < ApplicationController
  layout "auth", :only => [:new]
  def show
    @user = User.find(params[:id])
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
      redirect_to @user
    else
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
