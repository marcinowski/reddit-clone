class SubsController < ApplicationController
  layout 'sub', only: ["show", "mod"]
  def new
    unless logged_in?
      return head(:unauthorized)
    end
    if UserPermissions.can_add_subs?(current_user)
      @sub = Sub.new
      return render "new"
    else
      flash[:danger] = 'You can\'t create new subs.'
      return head(:forbidden)
    end
  end

  def create
    unless logged_in?
      return head(:unauthorized)
    end
    unless UserPermissions.can_add_subs?(current_user)
      return head(:forbidden)
    end
    sub = Sub.new(slug: sub_params)
    if sub.save
      begin
        SubModerator.create(sub: sub, user: current_user)
      rescue Exception => e
        logger.error "subs/create Failed to create sub moderator for sub #{sub.id}. Reason: #{e.message}"
      end
      return redirect_to sub_path(slug: sub.slug)
    else
      @sub = sub
      return render "new"
    end
  end

  def show
    if params[:slug] == 'all'
      @sub = Sub.new(slug: 'all')
      @posts = Post.all
    else
      @sub = Sub.includes(posts: [:rating_posts, :comments], sub_moderators: [:user]).find_by(slug: params[:slug])
      @posts = @sub.posts
    end
    # pagination
    limit = 10
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
    @mods = @sub.sub_moderators
    @posts = @posts.limit(limit).offset(offset)
  end

  def edit
    unless logged_in?
      return head(:forbidden)
    end
    sub = Sub.find_by(slug: params[:slug])
    if sub.nil?
      logger.warn "subs/edit sub #{params[:slug]} not found"
      return head(:not_found)
    end
    if UserPermissions.is_moderator?(current_user, sub)
      @sub = sub
      return render "edit"
    else
      return head(:forbidden)
    end
  end

  def update
    unless logged_in?
      return head(:unauthorized)
    end
    sub = Sub.find_by(slug: params[:slug])
    if sub.nil?
      logger.warn "subs/update sub #{params[:slug]} not found"
      return head(:not_found)
    end
    unless UserPermissions.is_moderator?(current_user, sub)
      return head(:forbidden)
    end
    description = params[:sub][:description]
    if sub.update(description: description)
      logger.info("Updating #{sub.slug}'s description")
      return redirect_to sub_path(slug: sub.slug)
    else
      @sub = sub
      return render "edit"
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

  def mod
    unless logged_in?
      redirect_to root_path
    end
    sub_slug = params[:slug]
    @sub = Sub.includes(sub_bans: [:user]).find_by(slug: sub_slug)
    unless UserPermissions.is_moderator?(current_user, @sub)
      redirect_to sub_path(slug: @sub.slug)
    end
  end

  private
  def sub_params
    params.require(:sub).require(:slug)
  end
end
