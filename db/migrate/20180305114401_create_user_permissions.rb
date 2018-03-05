class CreateUserPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_permissions do |t|
      t.references :user, index: {:unique=>true}, foreign_key: true
      t.boolean :is_superuser, default: false
      t.boolean :is_banned, default: false
      t.boolean :can_comment, default: true
      t.boolean :can_post, default: true
      t.boolean :can_login, default: true
      t.boolean :can_sub, default: true
    end
  end
end
