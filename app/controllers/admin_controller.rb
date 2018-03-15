class AdminController < ApplicationController
  layout 'admin'
  def index
    unless logged_in?
      redirect_to root_path
    end
    unless UserPermissions.is_superuser?(current_user)
      redirect_to root_path
    end
    @post_count = Post.count
    @user_count = User.count
    @sub_count = Sub.count
    @comment_count = Comment.count
  end

  def users
    @user = User.includes(
      :user_permission,
      sub_bans: [:sub],
      sub_moderators: [:sub]
    ).find_by(username: params[:username])
  end

  def action
    unless logged_in?
      logger.debug 'Unauthorized attempt to access admin/action endpoint'
      redirect_to root_path
    end
    action = params[:act]
    user = User.find(params[:user])
    unless UserPermissions.is_superuser?(current_user)
      logger.debug 'Permission denied for action #{action}'
      redirect_to root_path
    end
    logger.debug 'Performing #{action} for ${user.username} by #{current_user.username}'
    UserPermissions.send(action, user, current_user)
    redirect_to admin_users_path(username: user.username)
  end

  def mod_action
    unless logged_in?
      logger.debug 'Unauthorized attempt to access admin/mod_action endpoint'
      redirect_to root_path
    end
    action = params[:act]
    user = User.find(params[:user])
    sub = Sub.find(params[:sub])
    unless UserPermissions.is_moderator?(current_user, sub)
      logger.debug 'Permission denied for action #{action}'
      redirect_to root_path
    end
    logger.debug 'Performing #{action} for ${user.username} in r/{sub.slug} by #{current_user.username}'
    UserPermissions.send(action, user, sub, current_user)
    redirect_to admin_users_path(username: user.username)
  end
end
