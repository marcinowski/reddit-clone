class PostsController < ApplicationController
  include PostsHelper
  def new
    @title = 'Create a Post'
    if !logged_in?
      flash[:danger] = "You must be logged in to add posts."
      redirect_to root_url
      return
    end
    sub = Sub.find_by(slug: params[:sub_slug])
    if sub.nil?
      @post = Post.new
    else
      unless UserPermissions.can_post?(current_user, sub)
        flash[:danger] = "You can't add posts."
        redirect_to root_url
        return
      end
      @post = Post.new(sub_id: sub.id)
    end
  end

  def create
    if !logged_in?
      flash[:danger] = "You must be logged in to add posts."
      redirect_to root_url
      return
    end
    sub = Sub.find(post_params[:sub_id])
    unless UserPermissions.can_post?(current_user, sub)
      redirect_to root_url
      return
    end
    @post = Post.new(user_id: current_user.id, title: post_params[:title],
      url: post_params[:url], description: post_params[:description], sub: sub)
    if @post.save
      redirect_to post_comments_path(post_id: @post.id)
    else
      render "new"
    end
  end

  def index
    redirect_to root_url
  end

  def show
    redirect_to post_comments_path(params[:id])
  end

  def edit
    @title = 'Edit Post'
    if logged_in?
      @post = Post.find_by(id: params[:id], user: current_user)
      if @post.nil?
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def update
    if logged_in?
      @post = Post.find_by(id: params[:id], user: current_user)
      if @post.nil?
        redirect_to root_path
      else
        if @post.update(post_params)
          redirect_to post_comments_path(@post)
        else
          render "edit"
        end
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    if !logged_in?
      flash[:warning] = "You must be logged in to edit the posts"
      redirect_to root_path
    else
      post = Post.find_by(id: params[:id], user: current_user)
      if !post.nil?
        post.delete
      else
        flash[:danger] = "It's not your post dude"
      end
      redirect_to root_path
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, :sub_id)
    end
end
