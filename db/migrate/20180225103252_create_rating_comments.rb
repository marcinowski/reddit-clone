class CreateRatingComments < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_comments do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
