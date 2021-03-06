# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_06_173938) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.float "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_balances_on_created_at"
    t.index ["updated_at"], name: "index_balances_on_updated_at"
  end

  create_table "bank_transactions", force: :cascade do |t|
    t.float "plus"
    t.float "minus"
    t.string "unp"
    t.string "their_account"
    t.string "our_account"
    t.string "document_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "irregular", default: false
    t.string "note"
    t.string "contractor"
    t.string "purpose"
    t.index ["created_at"], name: "index_bank_transactions_on_created_at"
    t.index ["updated_at"], name: "index_bank_transactions_on_updated_at"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "erip_transactions", force: :cascade do |t|
    t.string "status"
    t.string "message"
    t.string "transaction_type"
    t.string "transaction_id"
    t.string "uid"
    t.string "order_id"
    t.decimal "amount"
    t.string "currency"
    t.string "description"
    t.string "tracking_id"
    t.datetime "transaction_created_at"
    t.datetime "expired_at"
    t.datetime "paid_at"
    t.boolean "test"
    t.string "payment_method_type"
    t.string "billing_address"
    t.string "customer"
    t.string "payment"
    t.string "erip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["transaction_id"], name: "index_erip_transactions_on_transaction_id", unique: true
    t.index ["user_id"], name: "index_erip_transactions_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_type"
    t.string "value"
    t.integer "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "repeated", default: false
  end

  create_table "macs", force: :cascade do |t|
    t.string "address"
    t.integer "user_id"
    t.index ["address"], name: "index_macs_on_address"
    t.index ["user_id"], name: "index_macs_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.text "short_desc"
    t.text "description"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "user_id"
    t.boolean "public"
    t.string "markup_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "show_on_homepage"
    t.datetime "show_on_homepage_till_date"
  end

  create_table "nfc_keys", force: :cascade do |t|
    t.string "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_nfc_keys_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "erip_transaction_id"
    t.datetime "paid_at", null: false
    t.decimal "amount", default: "0.0", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "payment_type", null: false
    t.string "payment_form", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.index ["erip_transaction_id"], name: "index_payments_on_erip_transaction_id"
    t.index ["project_id"], name: "index_payments_on_project_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "short_desc"
    t.text "full_desc"
    t.string "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "user_id"
    t.string "markup_type", default: "html"
    t.boolean "public", default: false
    t.string "project_status", default: "активный"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key"
  end

  create_table "thanks", force: :cascade do |t|
    t.string "name"
    t.text "short_desc"
    t.text "full_desc"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "user_id"
    t.string "markup_type", default: "html"
    t.boolean "public", default: false
    t.index ["user_id"], name: "index_thanks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "hacker_comment"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "bepaid_number"
    t.string "telegram_username"
    t.string "alice_greeting"
    t.datetime "last_seen_in_hackerspace"
    t.boolean "account_suspended"
    t.boolean "account_banned"
    t.float "monthly_payment_amount", default: 70.0
    t.string "github_username"
    t.text "ssh_public_key"
    t.boolean "is_learner", default: false
    t.integer "project_id"
    t.integer "guarantor1_id"
    t.integer "guarantor2_id"
    t.datetime "suspended_changed_at", default: "2010-12-31 18:21:50", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guarantor1_id"], name: "index_users_on_guarantor1_id"
    t.index ["guarantor2_id"], name: "index_users_on_guarantor2_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "nfc_keys", "users"
end
