class CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
  end

  def create
    if logged_in?
      @post = Post.find(params[:post_id])
      if !@post.nil?
        @comment = @post.comments.new(content: params[:comment][:content], user_id: current_user.id)
        if @comment.save
          redirect_to post_comments_path(@post)
        else
          flash[:error] = "Oops! Something went wrong! Please try again later."
          render @post
        end
      end
    else
      redirect_to post_comments_path(params[:post_id])
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    if logged_in?
      comment = Comment.find(params[:id])
      comment.update(content: params[:comment][:content])
      if comment.save
        redirect_to post_comments_path(params[:post_id])
        return
      end
    else
      redirect_to post_comments_path(params[:post_id])
      return
    end
    redirect_to posts_path
  end

  def destroy
    if logged_in?
      post = Post.find(params[:post_id])
      if !post.nil?
        comment = post.comments.find_by(id: params[:id], user_id: current_user.id)
        if !comment.nil?
          comment.delete
          redirect_to post_comments_path(post)
          return
        end
      end
    end
    redirect_to posts_path31
  end

end
