class CommentsController < ApplicationController
  layout 'sub'
  def index
    @post = Post.includes(:sub, :rating_posts, comments: [:rating_comments]).find(params[:post_id])
    @sub = @post.sub
  end

  def create
    unless logged_in?
      redirect_to post_comments_path(params[:post_id])
      return head(:unauthorized)
    end
    begin
      post = Post.includes(:sub).find(params[:post_id])
    rescue ActiveRecord::RecordNotFound
      logger.debug 'comments/create Post #{params[:post_id]} not found'
      return head(:not_found)
    end
    sub = post.sub
    unless UserPermissions.can_comment?(current_user, sub)
      flash[:danger] = "You can't add comments in this sub."
      logger.debug 'User #{current_user.username} can\'t add comments in sub #{sub.slug}'
      return head(:forbidden)
      return
    end
    comment = post.comments.new(content: params[:comment][:content], user_id: current_user.id)
    if comment.save
      redirect_to post_comments_path(post)
    else
      flash[:danger] = "Oops! Something went wrong! Please try again later."
      logger.error 'comments/create Failed to add comment. Reason: ' + comment.errors.full_messages.join('\n')
      return head(:internal_server_error)
    end
  end

  def edit
    @comment = Comment.include(:post).find(params[:id])
  end

  def update
    unless logged_in?
      return head(:unauthorized)
    end
    begin
      comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error 'Comment #{params[:id]} not found'
      return head(:not_found)
    end
    unless comment.user_id === current_user.id
      return head(:forbidden)
    end
    comment.update(content: params[:comment][:content])
    if comment.save
      return redirect_to post_comments_path(params[:post_id])
    else
      logger.error 'comments/update Failed to add comment. Reason: ' + comment.errors.full_messages.join('\n')
      return head(:internal_server_error)
    end
  end

  def destroy
    unless logged_in?
      return head(:unauthorized)
    end
    begin
      comment = Comment.includes(:post).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error 'Comment #{params[:id]} not found'
      return head(:not_found)
    end
    unless comment.user_id === current_user.id
      return head(:forbidden)
    end
    if comment.delete
      return redirect_to post_comments_path(comment.post)
    else
      logger.debug 'comments/delete Failed to destroy comment. Reason: ' + comment.errors.full_messages.join('\n')
      return head(:internal_server_error)
    end
  end
end
