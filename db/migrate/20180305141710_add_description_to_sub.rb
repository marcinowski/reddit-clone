class AddDescriptionToSub < ActiveRecord::Migration[5.1]
  def change
    add_column :subs, :description, :text
  end
end
