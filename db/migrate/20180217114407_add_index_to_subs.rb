class AddIndexToSubs < ActiveRecord::Migration[5.1]
  def change
    change_column :subs, :slug, :string, unique: true
    add_index :subs, :slug
  end
end
