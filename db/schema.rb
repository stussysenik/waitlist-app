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

ActiveRecord::Schema[8.1].define(version: 2026_03_02_120001) do
  create_table "daily_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "page_views_count", default: 0, null: false
    t.integer "referrals_count", default: 0, null: false
    t.integer "signups_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "waitlist_id", null: false
    t.index ["waitlist_id", "date"], name: "index_daily_stats_on_waitlist_id_and_date", unique: true
    t.index ["waitlist_id"], name: "index_daily_stats_on_waitlist_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "referee_id", null: false
    t.integer "referrer_id", null: false
    t.datetime "updated_at", null: false
    t.integer "waitlist_id", null: false
    t.index ["created_at"], name: "index_referrals_on_created_at"
    t.index ["referee_id"], name: "index_referrals_on_referee_id"
    t.index ["referrer_id", "referee_id"], name: "index_referrals_on_referrer_id_and_referee_id", unique: true
    t.index ["referrer_id"], name: "index_referrals_on_referrer_id"
    t.index ["waitlist_id", "created_at"], name: "index_referrals_on_waitlist_id_and_created_at"
    t.index ["waitlist_id"], name: "index_referrals_on_waitlist_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "ip_address"
    t.string "name"
    t.integer "position", null: false
    t.string "referral_code", null: false
    t.integer "referral_count", default: 0, null: false
    t.string "source"
    t.datetime "updated_at", null: false
    t.integer "waitlist_id", null: false
    t.index ["created_at"], name: "index_subscribers_on_created_at"
    t.index ["referral_code"], name: "index_subscribers_on_referral_code", unique: true
    t.index ["waitlist_id", "created_at"], name: "index_subscribers_on_waitlist_id_and_created_at"
    t.index ["waitlist_id", "email"], name: "index_subscribers_on_waitlist_id_and_email", unique: true
    t.index ["waitlist_id", "position"], name: "index_subscribers_on_waitlist_id_and_position", unique: true
    t.index ["waitlist_id"], name: "index_subscribers_on_waitlist_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.integer "plan", default: 0, null: false
    t.string "stripe_customer_id"
    t.datetime "trial_ends_at"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true
  end

  create_table "waitlists", force: :cascade do |t|
    t.string "brand_color", default: "#4F46E5"
    t.datetime "created_at", null: false
    t.string "cta_text", default: "Join the waitlist"
    t.text "description"
    t.string "headline"
    t.date "launch_date"
    t.string "name", null: false
    t.boolean "referral_enabled", default: true
    t.integer "referrals_count", default: 0, null: false
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.integer "subscribers_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["slug"], name: "index_waitlists_on_slug", unique: true
    t.index ["status"], name: "index_waitlists_on_status"
    t.index ["user_id"], name: "index_waitlists_on_user_id"
  end

  add_foreign_key "daily_stats", "waitlists"
  add_foreign_key "referrals", "subscribers", column: "referee_id"
  add_foreign_key "referrals", "subscribers", column: "referrer_id"
  add_foreign_key "referrals", "waitlists"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscribers", "waitlists"
  add_foreign_key "waitlists", "users"
end
