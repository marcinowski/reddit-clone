class CreateSubBans < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_bans do |t|
      t.references :user, foreign_key: true
      t.references :sub, foreign_key: true
      t.boolean :is_banned, default: false
      t.boolean :cannot_comment, default: false
      t.boolean :cannot_post, default: false
    end
    add_index :sub_bans, [:user_id, :sub_id], unique: true
  end
end
