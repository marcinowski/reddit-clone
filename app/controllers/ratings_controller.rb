class RatingsController < ApplicationController
  def vote
    unless logged_in?
      flash[:danger] = "Log in mate"
      return head(:unauthorized)
    end
    model = params[:model]
    id = params[:id].to_i
    if model.nil? || id.nil?
      return head(:bad_request)
    end
    d = params[:dir].to_i
    dir = d <=> 0
    if model === 'post'
      object = RatingPost.find_or_create_by(user_id: current_user.id, post_id: id)
    elsif model === 'comment'
      object = RatingComment.find_or_create_by(user_id: current_user.id, comment_id: id)
    else
      return head(:bad_request)
    end
    object.rating = dir
    if object.save
      return head(:ok)
    else
      logger.error "ratings/vote Error: "
      return head(:internal_server_error)
    end
  end
end
