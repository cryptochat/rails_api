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

ActiveRecord::Schema.define(version: 20161101143035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "session_keys", force: :cascade do |t|
    t.string   "uuid",        null: false
    t.binary   "public_key"
    t.binary   "private_key"
    t.binary   "shared_key"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "uuid",                                  null: false
    t.string   "email",                                 null: false
    t.string   "password",                              null: false
    t.string   "username"
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.string   "shared_key"
    t.string   "hmac_key"
    t.datetime "last_password_update"
    t.datetime "last_shared_key_update"
    t.integer  "failed_attempts_auth",   default: 0
    t.boolean  "is_active",              default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["failed_attempts_auth"], name: "index_users_on_failed_attempts_auth", using: :btree
    t.index ["is_active"], name: "index_users_on_is_active", using: :btree
    t.index ["last_password_update"], name: "index_users_on_last_password_update", using: :btree
    t.index ["last_shared_key_update"], name: "index_users_on_last_shared_key_update", using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
    t.index ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree
  end

end
