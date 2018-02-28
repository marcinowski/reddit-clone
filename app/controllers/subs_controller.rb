class SubsController < ApplicationController
  layout 'sub', only: ["show"]
  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(slug: sub_params)
    if @sub.save
      redirect_to sub_path(slug: @sub.slug)
    else
      render "new"
    end
  end

  def show
    if params[:slug] == 'all'
      @sub = Sub.new(slug: 'all')
      @posts = Post.all
    else
      @sub = Sub.find_by(slug: params[:slug])
      @posts = @sub.posts.all
    end
  end

  def destroy
  end

  def subscribe
    user_id = params[:user_id]
    sub_id = params[:sub_id]
    SubSubscription.create(user_id: user_id, sub_id: sub_id)
  end

  def unsubscribe
    user_id = params[:user_id]
    sub_id = params[:sub_id]
    SubSubscription.find_by(user_id: user_id, sub_id: sub_id).delete
  end

  private
  def sub_params
    params.require(:sub).require(:slug)
  end
end
