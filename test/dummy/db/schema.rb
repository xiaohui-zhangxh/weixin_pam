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

ActiveRecord::Schema.define(version: 20151211153353) do

  create_table "weixin_pam_public_accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "app_id"
    t.string   "app_secret"
    t.string   "api_url"
    t.string   "api_token"
    t.boolean  "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weixin_pam_user_accounts", force: :cascade do |t|
    t.integer  "weixin_pam_public_account_id"
    t.string   "uid"
    t.string   "nickname"
    t.string   "headshot"
    t.boolean  "subscribed"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "weixin_pam_user_accounts", ["weixin_pam_public_account_id"], name: "index_weixin_pam_user_accounts_on_weixin_pam_public_account_id"

end
