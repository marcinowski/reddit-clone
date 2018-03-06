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
      @posts = @sub.posts
    end
    # pagination
    limit = 2
    page = 0
    pcount = @posts.count
    unless params[:page].nil?
      page = params[:page].to_i.abs
    end
    offset = page * limit
    if offset < pcount - limit
      @next_page = page + 1
    end
    if page > 0
      @prev_page = page - 1
    end
    @posts = @posts.limit(limit).offset(offset)
  end

  def edit
    if logged_in?
      @sub = Sub.find_by(slug: params[:slug])
      unless @sub.nil?
        user = current_user
        if is_moderator? user, @sub
          render "edit"
          return
        end
      end
    end
    redirect_to root_path
  end

  def update
    if logged_in?
      @sub = Sub.find_by(slug: params[:slug])
      unless @sub.nil?
        description = params[:sub][:description]
        if @sub.update(description: description)
          logger.info("Updating")
          redirect_to sub_path(slug: @sub.slug)
          return
        else
          render "edit"
          return
        end
      end
    else
      redirect_to root_path
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
