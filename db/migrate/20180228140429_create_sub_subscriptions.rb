class CreateSubSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :sub, foreign_key: true

      t.timestamps
    end

    add_index :sub_subscriptions, [:user_id, :sub_id], unique: true
  end
end
