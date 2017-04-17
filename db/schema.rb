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

ActiveRecord::Schema.define(version: 20170415101956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "uuid-ossp"

  create_table "chat_attachment_types", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_chat_attachment_types_on_name", unique: true, using: :btree
  end

  create_table "chat_attachments", force: :cascade do |t|
    t.integer  "chat_message_id",         null: false
    t.integer  "chat_attachment_type_id", null: false
    t.string   "value"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["chat_attachment_type_id"], name: "index_chat_attachments_on_chat_attachment_type_id", using: :btree
    t.index ["chat_message_id"], name: "index_chat_attachments_on_chat_message_id", using: :btree
  end

  create_table "chat_channels", force: :cascade do |t|
    t.string  "name",                        null: false
    t.integer "cache_user_ids", default: [],              array: true
    t.index ["cache_user_ids"], name: "index_chat_channels_on_cache_user_ids", using: :gin
    t.index ["name"], name: "index_chat_channels_on_name", unique: true, using: :btree
  end

  create_table "chat_channels_users", force: :cascade do |t|
    t.integer "chat_channel_id"
    t.integer "user_id"
    t.index ["chat_channel_id"], name: "index_chat_channels_users_on_chat_channel_id", using: :btree
    t.index ["user_id"], name: "index_chat_channels_users_on_user_id", using: :btree
  end

  create_table "chat_messages", force: :cascade do |t|
    t.integer  "chat_channel_id"
    t.integer  "user_id"
    t.text     "text",                            null: false
    t.boolean  "has_attachments", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_read",         default: false
    t.datetime "readed_at"
    t.integer  "interlocutor_id"
    t.index ["chat_channel_id"], name: "index_chat_messages_on_chat_channel_id", using: :btree
    t.index ["user_id"], name: "index_chat_messages_on_user_id", using: :btree
  end

  create_table "session_keys", force: :cascade do |t|
    t.string   "identifier",  null: false
    t.binary   "public_key"
    t.binary   "private_key"
    t.binary   "shared_key"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "uuid",                                   null: false
    t.string   "email",                                  null: false
    t.string   "username"
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.string   "shared_key"
    t.string   "hmac_key"
    t.datetime "last_password_update"
    t.datetime "last_shared_key_update"
    t.integer  "failed_attempts_auth",   default: 0
    t.boolean  "is_active",              default: true
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.binary   "password"
    t.string   "full_name",                              null: false
    t.boolean  "is_online",              default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["failed_attempts_auth"], name: "index_users_on_failed_attempts_auth", using: :btree
    t.index ["full_name"], name: "index_users_on_full_name", using: :btree
    t.index ["is_active"], name: "index_users_on_is_active", using: :btree
    t.index ["last_password_update"], name: "index_users_on_last_password_update", using: :btree
    t.index ["last_shared_key_update"], name: "index_users_on_last_shared_key_update", using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
    t.index ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree
  end

  add_foreign_key "chat_attachments", "chat_attachment_types"
  add_foreign_key "chat_attachments", "chat_messages"
  add_foreign_key "chat_channels_users", "chat_channels"
  add_foreign_key "chat_channels_users", "users"
  add_foreign_key "chat_messages", "chat_channels"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "chat_messages", "users", column: "interlocutor_id"
end
