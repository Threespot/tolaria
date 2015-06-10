# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150609232013) do

  create_table "administrators", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                      null: false
    t.string   "name",                                       null: false
    t.string   "organization",                               null: false
    t.string   "passcode",            limit: 60,             null: false
    t.datetime "passcode_expires_at",                        null: false
    t.string   "auth_token",          limit: 32,             null: false
    t.datetime "account_unlocks_at",                         null: false
    t.integer  "lockout_strikes",                default: 0, null: false
    t.integer  "total_strikes",                  default: 0, null: false
    t.integer  "sessions_created",               default: 0, null: false
  end

  add_index "administrators", ["auth_token"], name: "index_administrators_on_auth_token"
  add_index "administrators", ["email"], name: "index_administrators_on_email"

  create_table "blog_post_categories", force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.integer "category_id",  null: false
  end

  add_index "blog_post_categories", ["blog_post_id"], name: "index_blog_post_categories_on_blog_post_id"
  add_index "blog_post_categories", ["category_id"], name: "index_blog_post_categories_on_category_id"

  create_table "blog_posts", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "title",        null: false
    t.datetime "published_at", null: false
    t.text     "teaser"
    t.text     "summary"
    t.text     "body"
    t.string   "color"
    t.text     "portrait"
    t.text     "attachment"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "label",      null: false
    t.string   "slug",       null: false
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug"

  create_table "footnotes", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "blog_post_id", null: false
    t.text     "description"
    t.text     "url"
  end

  add_index "footnotes", ["blog_post_id"], name: "index_footnotes_on_blog_post_id"

end
