module PostsHelper
  def is_post_owner?
    post = Post.find_by(id: params[:post_id], user: current_user)
    !post.nil?
  end
end
