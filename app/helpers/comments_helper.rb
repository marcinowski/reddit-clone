module CommentsHelper
  def is_comment_owner?(comment)
    unless current_user.nil?
      comment.user_id == current_user.id
    end
  end
end
