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

ActiveRecord::Schema.define(version: 20161008044016) do

  create_table "categories", force: true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
  end

  create_table "complaints", force: true do |t|
    t.string   "complaint_title"
    t.datetime "received_date"
    t.integer  "job_id"
    t.integer  "expert_id"
    t.integer  "user_id"
    t.string   "status"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumer_manuals", force: true do |t|
    t.integer  "user_id"
    t.integer  "consumer_id"
    t.integer  "manual_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "stripetoken"
    t.integer  "pay"
  end

  create_table "device_notifications", force: true do |t|
    t.string   "device_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_tokens", force: true do |t|
    t.string   "device_token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expert_notifications", force: true do |t|
    t.string   "expert_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expert_tags", force: true do |t|
    t.string   "tag_name"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experts", force: true do |t|
    t.string   "expert_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "expert_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.string   "address"
    t.string   "zipcode"
    t.string   "email"
    t.integer  "expert_mode",                default: 1
  end

  create_table "feedbacks", force: true do |t|
    t.text     "description"
    t.integer  "rating",      default: 0
    t.integer  "job_id"
    t.integer  "expert_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.string   "description"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.string   "issue_name"
    t.datetime "received_date"
    t.datetime "completed_date"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "make"
    t.string   "model"
    t.integer  "input_type"
    t.string   "current_status"
    t.text     "visit_address"
    t.string   "restart_reason"
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.string   "job_type"
    t.string   "cancelled_by"
    t.integer  "payment"
  end

  create_table "manuals", force: true do |t|
    t.integer  "sub_category_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "download_url"
    t.string   "download_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_parts", force: true do |t|
    t.string   "part_name"
    t.integer  "job_id"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",         limit: 24
    t.float    "total_amount",  limit: 24
    t.text     "product_image"
    t.integer  "quantity"
    t.string   "status"
  end

  create_table "ratings", force: true do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_issues", force: true do |t|
    t.string   "description"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "report_by"
  end

  create_table "sub_categories", force: true do |t|
    t.string   "sub_cat_name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "support_requests", force: true do |t|
    t.integer  "user_id"
    t.string   "issue_description"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                            default: "",   null: false
    t.string   "encrypted_password",               default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
    t.string   "username"
    t.integer  "phone",                  limit: 8
    t.boolean  "notification_status",              default: true
    t.integer  "call_time",                        default: 1
    t.string   "city"
    t.integer  "expert_id"
    t.integer  "delete_at",                        default: 0,    null: false
    t.string   "stripetoken"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
