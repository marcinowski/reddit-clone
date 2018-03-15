class PostsController < ApplicationController
  include PostsHelper

  def new
    unless logged_in?
      flash[:danger] = "You must be logged in to add posts."
      return head(:unauthorized)
    end
    sub = Sub.find_by(slug: params[:sub_slug])
    if sub.nil?
      post = Post.new
    else
      unless UserPermissions.can_post?(current_user, sub)
        logger.debug "User #{current_user.id} cannot add posts to sub #{sub.id}"
        flash[:danger] = "You can't add posts."
        return head(:forbidden)
      end
      post = Post.new(sub_id: sub.id)
    end
    @title = 'Create a Post'
    @post = post
  end

  def create
    unless logged_in?
      flash[:danger] = "You must be logged in to add posts."
      return redirect_to root_url
    end
    begin
      sub = Sub.find(post_params[:sub_id])
    rescue ActiveRecord::RecordNotFound
      return head(:not_found)
    end
    unless UserPermissions.can_post?(current_user, sub)
      return redirect_to root_url
    end
    post = sub.posts.new(user_id: current_user.id, title: post_params[:title],
      url: post_params[:url], description: post_params[:description])
    if post.save
      return redirect_to post_comments_path(post)
    else
      logger.error post.errors.full_messages.join('\n')
      @post = post
      return render "new"
    end
  end

  def index
    redirect_to root_url
  end

  def show
    redirect_to post_comments_path(params[:id])
  end

  def edit
    unless logged_in?
      return head(:unauthorized)
    end
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.debug "Post #{params[:id]} not found"
      return head(:not_found)
    end
    unless post.user_id === current_user.id
      return head(:forbidden)
    end
    @post = post
    @title = 'Edit Post'
  end

  def update
    unless logged_in?
      return head(:unauthorized)
    end
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.debug "Post #{params[:id]} not found"
      return head(:not_found)
    end
    unless post.user_id === current_user.id
      return head(:forbidden)
    end
    if post.update(post_params)
      return redirect_to post_comments_path(post)
    else
      @post = post
      return render "edit"
    end
  end

  def destroy
    unless logged_in?
      return head(:unauthorized)
    end
    begin
      post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.debug "Post #{params[:id]} not found"
      return head(:not_found)
    end
    unless post.user_id === current_user.id
      return head(:forbidden)
    end
    if post.delete
      return redirect_to root_path
    else
      logger.error "posts/destroy Couldn't delete post #{post.id}"
      return head(:internal_server_error)
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, :sub_id)
    end
end
