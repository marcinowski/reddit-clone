class AddUniqueSlugToSubs < ActiveRecord::Migration[5.1]
  def change
    change_column :subs, :slug, :string, :unique => true, :null => false
  end
end
