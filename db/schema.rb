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

ActiveRecord::Schema.define(version: 2021_09_20_223006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_trails", force: :cascade do |t|
    t.integer "record_id"
    t.string "record_type", limit: 30
    t.string "event", limit: 20
    t.integer "user_id"
    t.datetime "created_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "permalink", limit: 20
    t.boolean "admin_use"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true
    t.integer "database_rowid"
    t.bigint "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "generate_stats", default: false
    t.boolean "early_bird", default: false
    t.boolean "sports_loaded", default: false
    t.boolean "volunteers_loaded", default: false
    t.boolean "group_registrations_closed", default: false
    t.boolean "restricted_sports_allocated", default: false
    t.boolean "indiv_draws_complete", default: false
    t.boolean "team_draws_complete", default: false
    t.boolean "evening_sessions_final", default: false
    t.boolean "updates_restricted", default: false
    t.boolean "syg_is_happening", default: false
    t.boolean "syg_is_finished", default: false
    t.integer "new_group_sports_allocation_factor", default: 0
    t.integer "sport_coord_sports_allocation_factor", default: 0
    t.integer "missed_out_sports_allocation_factor", default: 0
    t.integer "small_division_ceiling", default: 20
    t.integer "medium_division_ceiling", default: 40
    t.decimal "full_fee", precision: 8, scale: 2, default: "109.0", null: false
    t.decimal "day_visitor_adjustment", precision: 8, scale: 2, default: "1.0", null: false
    t.decimal "coordinator_adjustment", precision: 8, scale: 2, default: "0.5", null: false
    t.decimal "spectator_adjustment", precision: 8, scale: 2, default: "0.77", null: false
    t.decimal "primary_age_adjustment", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "daily_adjustment", precision: 8, scale: 2, default: "0.55", null: false
    t.decimal "helper_adjustment", precision: 8, scale: 2, default: "0.55", null: false
    t.decimal "early_bird_discount", precision: 8, scale: 2, default: "10.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "info_email", limit: 100, default: ""
    t.string "admin_email", limit: 100, default: ""
    t.string "rego_email", limit: 100, default: ""
    t.string "sports_email", limit: 100, default: ""
    t.string "sports_admin_email", limit: 100, default: ""
    t.string "ticket_email", limit: 100, default: ""
    t.string "lost_property_email", limit: 100, default: ""
    t.string "finance_email", limit: 100, default: ""
    t.string "comms_email", limit: 100, default: ""
    t.string "social_twitter_url", default: ""
    t.string "social_facebook_url", default: ""
    t.string "social_facebook_gc_url", default: ""
    t.string "social_instagram_url", default: ""
    t.string "public_website", default: ""
    t.string "rego_website", default: ""
    t.string "website_host", default: ""
    t.integer "this_year", default: 1991
    t.date "first_day_of_syg"
    t.date "early_bird_cutoff"
    t.date "deposit_due_date"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.string "classification", limit: 10, null: false
    t.boolean "active", default: true
    t.integer "max_indiv_entries_group", default: 0, null: false
    t.integer "max_team_entries_group", default: 0, null: false
    t.integer "max_entries_indiv", default: 0, null: false
    t.string "draw_type", limit: 20, null: false
    t.boolean "bonus_for_officials", default: false
    t.string "court_name", limit: 20, default: "Court"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "updated_by"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.string "database_code", limit: 4
    t.string "address"
    t.bigint "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
