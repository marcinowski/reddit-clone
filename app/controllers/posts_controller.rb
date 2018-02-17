class PostsController < ApplicationController
  include PostsHelper
  def new
    if !logged_in?
      flash[:error] = "You must be logged in to add posts."
      redirect_to root_url
      return
    else
      sub = Sub.find_by(slug: params[:sub_slug])
      @subs = Sub.pluck(:slug, :id)
      if sub.nil?
        @post = Post.new
      else
        @post = Post.new(sub_id: sub.id)
      end
    end
  end

  def create
    post = Post.new(user: current_user, title: post_params[:title],
      url: post_params[:url], description: post_params[:description], sub_id: post_params[:sub_id])
    if post.save
      redirect_to post_path(post)
    else
      redirect_to new_post_path
    end
  end

  def index
    @posts = Post.all
  end

  def show
    redirect_to post_comments_path(params[:id])
  end

  def edit
    if logged_in?
      @post = Post.find_by(id: params[:id], user: current_user)
      if @post.nil?
        redirect_to posts_path
      end
    else
      redirect_to posts_path
    end
  end

  def update
    if logged_in?
      @post = Post.find_by(id: params[:id], user: current_user)
      if @post.nil?
        redirect_to posts_path
      else
        @post.update(post_params)
        redirect_to @post
      end
    else
      redirect_to posts_path
    end
  end

  def destroy
    if !logged_in?
      flash[:warning] = "You must be logged in to edit the posts"
      redirect_to posts_path
    else
      post = Post.find_by(id: params[:id], user: current_user)
      if !post.nil?
        post.delete
      else
        flash[:error] = "It's not your post dude"
      end
      redirect_to posts_path
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, :sub_id)
    end
end
