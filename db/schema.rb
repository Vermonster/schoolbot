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

ActiveRecord::Schema.define(version: 20170307152609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_assignments", force: :cascade do |t|
    t.integer  "bus_id"
    t.integer  "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bus_assignments", ["bus_id"], name: "index_bus_assignments_on_bus_id", using: :btree
  add_index "bus_assignments", ["student_id"], name: "index_bus_assignments_on_student_id", using: :btree

  create_table "bus_locations", force: :cascade do |t|
    t.integer  "bus_id",       null: false
    t.float    "latitude",     null: false
    t.float    "longitude",    null: false
    t.text     "heading",      null: false
    t.datetime "recorded_at",  null: false
    t.float    "distance"
    t.float    "speed"
    t.float    "acceleration"
    t.text     "reason"
    t.text     "zone"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "bus_locations", ["bus_id", "recorded_at"], name: "index_bus_locations_on_bus_id_and_recorded_at", unique: true, using: :btree
  add_index "bus_locations", ["bus_id"], name: "index_bus_locations_on_bus_id", using: :btree
  add_index "bus_locations", ["recorded_at"], name: "index_bus_locations_on_recorded_at", using: :btree

  create_table "buses", force: :cascade do |t|
    t.integer  "district_id", null: false
    t.text     "identifier",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "buses", ["district_id", "identifier"], name: "index_buses_on_district_id_and_identifier", unique: true, using: :btree
  add_index "buses", ["district_id"], name: "index_buses_on_district_id", using: :btree

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
    t.text     "name",                             null: false
    t.text     "slug",                             null: false
    t.text     "contact_phone",                    null: false
    t.text     "contact_email",                    null: false
    t.text     "api_secret",                       null: false
    t.text     "zonar_customer",                   null: false
    t.text     "zonar_username",                   null: false
    t.text     "zonar_password",                   null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "logo_file_name",                   null: false
    t.string   "logo_content_type",                null: false
    t.integer  "logo_file_size",                   null: false
    t.datetime "logo_updated_at",                  null: false
    t.boolean  "is_active",         default: true, null: false
  end

  add_index "districts", ["api_secret"], name: "index_districts_on_api_secret", unique: true, using: :btree
  add_index "districts", ["slug"], name: "index_districts_on_slug", unique: true, using: :btree

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.text     "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
    t.boolean  "content_available",            default: false
    t.text     "notification"
    t.integer  "user_id"
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
  add_index "rpush_notifications", ["user_id"], name: "index_rpush_notifications_on_user_id", using: :btree

  create_table "schools", force: :cascade do |t|
    t.integer  "district_id", null: false
    t.text     "name",        null: false
    t.text     "address",     null: false
    t.float    "latitude",    null: false
    t.float    "longitude",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "schools", ["district_id"], name: "index_schools_on_district_id", using: :btree

  create_table "student_labels", force: :cascade do |t|
    t.integer  "student_id", null: false
    t.integer  "school_id",  null: false
    t.integer  "user_id",    null: false
    t.text     "nickname",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "student_labels", ["nickname", "user_id"], name: "index_student_labels_on_nickname_and_user_id", unique: true, using: :btree
  add_index "student_labels", ["school_id"], name: "index_student_labels_on_school_id", using: :btree
  add_index "student_labels", ["student_id", "user_id"], name: "index_student_labels_on_student_id_and_user_id", unique: true, using: :btree
  add_index "student_labels", ["student_id"], name: "index_student_labels_on_student_id", using: :btree
  add_index "student_labels", ["user_id"], name: "index_student_labels_on_user_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "district_id", null: false
    t.text     "digest",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "students", ["digest", "district_id"], name: "index_students_on_digest_and_district_id", unique: true, using: :btree
  add_index "students", ["district_id"], name: "index_students_on_district_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "district_id",                                  null: false
    t.text     "email",                                        null: false
    t.text     "password_digest",                              null: false
    t.text     "authentication_token",                         null: false
    t.text     "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "name",                                         null: false
    t.text     "street",                                       null: false
    t.text     "city",                                         null: false
    t.text     "state",                                        null: false
    t.text     "zip_code",                                     null: false
    t.float    "latitude",                                     null: false
    t.float    "longitude",                                    null: false
    t.text     "confirmation_token"
    t.datetime "confirmed_at"
    t.text     "unconfirmed_email"
    t.text     "locale",                   default: "en",      null: false
    t.text     "device_token"
    t.boolean  "enable_notifications",     default: false
    t.float    "notification_radius",      default: 0.5
    t.string   "notification_time_of_day", default: "day"
    t.string   "notification_days",        default: "weekday"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["district_id"], name: "index_users_on_district_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "bus_assignments", "buses", on_delete: :restrict
  add_foreign_key "bus_assignments", "students", on_delete: :cascade
  add_foreign_key "bus_locations", "buses", on_delete: :restrict
  add_foreign_key "buses", "districts", on_delete: :restrict
  add_foreign_key "rpush_notifications", "users"
  add_foreign_key "schools", "districts", on_delete: :restrict
  add_foreign_key "student_labels", "schools", on_delete: :restrict
  add_foreign_key "student_labels", "students", on_delete: :cascade
  add_foreign_key "student_labels", "users", on_delete: :cascade
  add_foreign_key "students", "districts", on_delete: :restrict
  add_foreign_key "users", "districts", on_delete: :restrict
end
