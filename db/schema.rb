# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_03_100233) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.float "state", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_balances_on_created_at"
    t.index ["updated_at"], name: "index_balances_on_updated_at"
  end

  create_table "bank_transactions", force: :cascade do |t|
    t.string "contractor"
    t.datetime "created_at", precision: nil, null: false
    t.string "document_number"
    t.boolean "irregular", default: false
    t.float "minus"
    t.string "note"
    t.string "our_account"
    t.float "plus"
    t.string "purpose"
    t.string "their_account"
    t.string "unp"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_bank_transactions_on_created_at"
    t.index ["updated_at"], name: "index_bank_transactions_on_updated_at"
  end

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "encrypted_password", null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "erip_transactions", force: :cascade do |t|
    t.decimal "amount"
    t.string "billing_address"
    t.datetime "created_at", precision: nil, null: false
    t.string "currency"
    t.string "customer"
    t.string "description"
    t.string "erip"
    t.datetime "expired_at", precision: nil
    t.string "message"
    t.string "order_id"
    t.datetime "paid_at", precision: nil
    t.string "payment"
    t.string "payment_method_type"
    t.string "status"
    t.boolean "test"
    t.string "tracking_id"
    t.datetime "transaction_created_at", precision: nil
    t.string "transaction_id"
    t.string "transaction_type"
    t.string "uid"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["transaction_id"], name: "index_erip_transactions_on_transaction_id", unique: true
    t.index ["user_id"], name: "index_erip_transactions_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "device_id"
    t.string "event_type"
    t.boolean "repeated", default: false
    t.datetime "updated_at", precision: nil
    t.string "value"
  end

  create_table "macs", force: :cascade do |t|
    t.string "address"
    t.integer "user_id"
    t.index ["address"], name: "index_macs_on_address"
    t.index ["user_id"], name: "index_macs_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "markup_type"
    t.string "photo_content_type"
    t.string "photo_file_name"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.boolean "public"
    t.text "short_desc"
    t.boolean "show_on_homepage"
    t.datetime "show_on_homepage_till_date", precision: nil
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "nfc_keys", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_nfc_keys_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", default: "0.0", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.date "end_date"
    t.integer "erip_transaction_id"
    t.datetime "paid_at", precision: nil, null: false
    t.string "payment_form", null: false
    t.string "payment_type", null: false
    t.integer "project_id"
    t.date "start_date"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["erip_transaction_id"], name: "index_payments_on_erip_transaction_id"
    t.index ["project_id"], name: "index_payments_on_project_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "full_desc"
    t.string "image"
    t.string "markup_type", default: "html"
    t.string "name"
    t.string "photo_content_type"
    t.string "photo_file_name"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.string "project_status", default: "активный"
    t.boolean "public", default: false
    t.text "short_desc"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "public_ssh_keys", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_public_ssh_keys_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "key", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "value"
    t.index ["key"], name: "index_settings_on_key"
  end

  create_table "tariffs", force: :cascade do |t|
    t.boolean "access_allowed"
    t.boolean "accessible_to_user", default: false, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.decimal "monthly_price"
    t.string "name"
    t.string "ref_name"
    t.datetime "updated_at", null: false
  end

  create_table "thanks", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "full_desc"
    t.string "image"
    t.string "markup_type", default: "html"
    t.string "name"
    t.string "photo_content_type"
    t.string "photo_file_name"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.boolean "public", default: false
    t.text "short_desc"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_thanks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "account_banned"
    t.boolean "account_suspended"
    t.string "alice_greeting"
    t.integer "bepaid_number"
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "github_username"
    t.integer "guarantor1_id"
    t.integer "guarantor2_id"
    t.string "hacker_comment"
    t.boolean "is_learner", default: false
    t.string "last_name"
    t.datetime "last_seen_in_hackerspace", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.date "paid_until"
    t.string "photo_content_type"
    t.string "photo_file_name"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
    t.integer "project_id"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "suspended_changed_at", precision: nil, default: "2010-12-31 18:21:50", null: false
    t.datetime "tariff_changed_at"
    t.integer "tariff_id"
    t.string "telegram_username"
    t.string "tg_auth_token"
    t.datetime "tg_auth_token_expiry", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guarantor1_id"], name: "index_users_on_guarantor1_id"
    t.index ["guarantor2_id"], name: "index_users_on_guarantor2_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tariff_id"], name: "index_users_on_tariff_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "nfc_keys", "users"
  add_foreign_key "public_ssh_keys", "users"
  add_foreign_key "users", "tariffs"
end
