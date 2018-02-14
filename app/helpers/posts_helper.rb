module PostsHelper
  def is_owner?
    post = Post.find_by(id: params[:id], user: current_user)
    !post.nil?
  end
end
