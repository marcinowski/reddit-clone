class AddIndexToRatingPostsAndComments < ActiveRecord::Migration[5.1]
  def change
    add_index :rating_comments, [:user_id, :comment_id]
    add_index :rating_posts, [:user_id, :post_id]
  end
end
