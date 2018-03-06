# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180305141710) do

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "url"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sub_id"
    t.index ["sub_id"], name: "index_posts_on_sub_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "rating_comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "comment_id"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_rating_comments_on_comment_id"
    t.index ["user_id", "comment_id"], name: "index_rating_comments_on_user_id_and_comment_id"
    t.index ["user_id"], name: "index_rating_comments_on_user_id"
  end

  create_table "rating_posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_rating_posts_on_post_id"
    t.index ["user_id", "post_id"], name: "index_rating_posts_on_user_id_and_post_id"
    t.index ["user_id"], name: "index_rating_posts_on_user_id"
  end

  create_table "search_tables", force: :cascade do |t|
    t.string "word"
    t.string "table"
    t.integer "ref_id"
    t.index ["word", "table", "ref_id"], name: "index_search_tables_on_word_and_table_and_ref_id"
    t.index ["word"], name: "index_search_tables_on_word"
  end

  create_table "sub_bans", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sub_id"
    t.boolean "is_banned", default: false
    t.boolean "cannot_comment", default: false
    t.boolean "cannot_post", default: false
    t.index ["sub_id"], name: "index_sub_bans_on_sub_id"
    t.index ["user_id", "sub_id"], name: "index_sub_bans_on_user_id_and_sub_id", unique: true
    t.index ["user_id"], name: "index_sub_bans_on_user_id"
  end

  create_table "sub_moderators", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sub_id"
    t.index ["sub_id"], name: "index_sub_moderators_on_sub_id"
    t.index ["user_id", "sub_id"], name: "index_sub_moderators_on_user_id_and_sub_id", unique: true
    t.index ["user_id"], name: "index_sub_moderators_on_user_id"
  end

  create_table "sub_subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sub_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_id"], name: "index_sub_subscriptions_on_sub_id"
    t.index ["user_id", "sub_id"], name: "index_sub_subscriptions_on_user_id_and_sub_id", unique: true
    t.index ["user_id"], name: "index_sub_subscriptions_on_user_id"
  end

  create_table "subs", force: :cascade do |t|
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["slug"], name: "index_subs_on_slug"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "is_superuser", default: false
    t.boolean "is_banned", default: false
    t.boolean "can_comment", default: true
    t.boolean "can_post", default: true
    t.boolean "can_login", default: true
    t.boolean "can_sub", default: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
