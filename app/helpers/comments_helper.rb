module CommentsHelper
  def is_comment_owner?(comment)
    comment.user_id == @current_user.id
  end
end
