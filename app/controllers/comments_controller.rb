class CommentsController < ApplicationController
  layout 'sub'
  def index
    @post = Post.includes(:sub, :rating_posts, comments: [:rating_comments]).find(params[:post_id])
    @sub = @post.sub
  end

  def create
    if logged_in?
      post = Post.includes(:sub).find(params[:post_id])
      if !post.nil?
        sub = post.sub
        unless UserPermissions.can_comment?(current_user, sub)
          flash[:danger] = "You can't add comments in this sub."
          redirect_to post_comments_path(post)
          return
        end
        comment = post.comments.new(content: params[:comment][:content], user_id: current_user.id)
        if comment.save
          redirect_to post_comments_path(post)
        else
          flash[:danger] = "Oops! Something went wrong! Please try again later."
          render post
        end
      end
    else
      redirect_to post_comments_path(params[:post_id])
    end
  end

  def edit
    @comment = Comment.include(:post).find(params[:id])
  end

  def update
    if logged_in?
      comment = Comment.find_by(id: params[:id], user_id: current_user.id)
      if comment.nil?
        redirect_to post_comments_path(post_id: params[:post_id])
        return
      else
        comment.update(content: params[:comment][:content])
        if comment.save
          redirect_to post_comments_path(params[:post_id])
          return
        end
      end
    else
      redirect_to post_comments_path(params[:post_id])
      return
    end
    redirect_to root_path
  end

  def destroy
    post = Post.includes(:comments).find(params[:post_id])
    if logged_in?
      if !post.nil?
        comment = post.comments.find_by(id: params[:id], user_id: current_user.id)
        if !comment.nil?
          comment.delete
          redirect_to post_comments_path(post)
          return
        end
      end
    end
    redirect_to post_comments_path(post)
  end

end
