class CreateRatingPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_posts do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
