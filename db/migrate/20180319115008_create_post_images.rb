class CreatePostImages < ActiveRecord::Migration[5.1]
  def change
    create_table :post_images do |t|
      t.string :site
      t.string :site_id
      t.string :url
      t.string :thumbnail_url
      t.string :embedded_url
      t.references :post, index: {:unique=>true}, foreign_key: true

      t.timestamps
    end
  end
end
