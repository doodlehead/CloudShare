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

ActiveRecord::Schema.define(version: 20170330142720) do

  create_table "assets", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "shared_with",        default: ""
    t.boolean  "tempfile",           default: false
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "keys", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary   "ekey"
    t.binary   "iv"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.string   "shared_files",    default: ""
    t.binary   "public_key"
    t.binary   "eprivate_key"
  end

end
