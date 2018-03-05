class CreateSubModerators < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_moderators do |t|
      t.references :user, foreign_key: true
      t.references :sub, foreign_key: true
    end
    add_index :sub_moderators, [:user_id, :sub_id], unique: true
  end
end
