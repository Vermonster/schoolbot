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

ActiveRecord::Schema.define(version: 20150722173319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "districts", force: :cascade do |t|
    t.text     "name",           null: false
    t.text     "slug",           null: false
    t.text     "contact_phone",  null: false
    t.text     "contact_email",  null: false
    t.text     "api_secret",     null: false
    t.text     "zonar_customer", null: false
    t.text     "zonar_username", null: false
    t.text     "zonar_password", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "districts", ["api_secret"], name: "index_districts_on_api_secret", unique: true, using: :btree
  add_index "districts", ["slug"], name: "index_districts_on_slug", unique: true, using: :btree

  create_table "schools", force: :cascade do |t|
    t.integer "district_id", null: false
    t.text    "name",        null: false
    t.text    "address",     null: false
    t.float   "latitude",    null: false
    t.float   "longitude",   null: false
  end

  add_index "schools", ["district_id"], name: "index_schools_on_district_id", using: :btree

  create_table "student_labels", force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "student_id", null: false
    t.string  "nickname",         null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "sha"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "district_id",                         null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "authentication_token",                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "zip_code"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["district_id"], name: "index_users_on_district_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "schools", "districts", on_delete: :restrict
  add_foreign_key "users", "districts", on_delete: :restrict
end
