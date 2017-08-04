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

ActiveRecord::Schema.define(version: 20170804203546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "encrypted_password", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "erip_transactions", force: :cascade do |t|
    t.string   "status"
    t.string   "message"
    t.string   "transaction_type"
    t.string   "transaction_id"
    t.string   "uid"
    t.string   "order_id"
    t.decimal  "amount"
    t.string   "currency"
    t.string   "description"
    t.string   "tracking_id"
    t.datetime "transaction_created_at"
    t.datetime "expired_at"
    t.datetime "paid_at"
    t.boolean  "test"
    t.string   "payment_method_type"
    t.json     "billing_address"
    t.json     "customer"
    t.json     "payment"
    t.json     "erip"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "event_type"
    t.string   "value"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "repeated",   default: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "short_desc"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_id"
    t.boolean  "public"
    t.string   "markup_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_homepage"
    t.datetime "show_on_homepage_till_date"
    t.string   "url"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "short_desc"
    t.text     "full_desc"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_id"
    t.string   "markup_type",        default: "html"
    t.boolean  "public",             default: false
    t.string   "project_status",     default: "активный"
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.string   "EripTransaction"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key",         null: false
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.index ["key"], name: "index_settings_on_key", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: "",  null: false
    t.string   "encrypted_password",        default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hacker_comment"
    t.string   "badge_comment"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "bepaid_number"
    t.float    "monthly_payment_amount",    default: 0.0
    t.float    "next_month_payment_amount"
    t.integer  "next_month"
    t.float    "current_debt"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id", using: :btree
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_users_roles_on_user_id", using: :btree
  end

end
