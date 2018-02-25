class RatingsController < ApplicationController
  def vote
    model = params[:model]
    id = params[:id]
    if model.nil? || id.nil?
      head 500
      return
    end
    if params[:dir] == 0
      dir = 0
    else
      dir = params[:dir] > 0 ? 1 : -1
    end
    if model == 'post'
      object = RatingPost.find_by(user_id: @current_user.id, post_id: id)
      if object.nil?
        RatingPost.create(user_id: @current_user.id, post_id: id, rating: dir)
      else
        object.rating = dir
        object.save
      end
    elsif model == 'comment'
      object = RatingComment.find_by(user_id: @current_user.id, post_id: id)
      if object.nil?
        RatingComment.create(user_id: @current_user.id, post_id: id, rating: dir)
      else
        object.rating = dir
        object.save
      end
    else
      head 500
      return
    end
    head 200
  end
end
