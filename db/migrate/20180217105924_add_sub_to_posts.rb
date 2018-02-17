class AddSubToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :sub, foreign_key: true
  end
end
