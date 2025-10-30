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

ActiveRecord::Schema[8.0].define(version: 2025_10_30_161022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
  end

  create_table "contacts", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.text "how_we_met"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", null: false
    t.index ["creator_id"], name: "index_contacts_on_creator_id"
    t.index ["owner_type", "owner_id"], name: "index_contacts_on_owner"
  end

  create_table "events", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.datetime "starts_at", null: false
    t.integer "duration_in_minutes", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_events_on_owner"
  end

  create_table "follow_up_tasks", force: :cascade do |t|
    t.bigint "invitation_id", null: false
    t.bigint "user_id", null: false
    t.datetime "due_at", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_id"], name: "index_follow_up_tasks_on_invitation_id", unique: true
    t.index ["user_id"], name: "index_follow_up_tasks_on_user_id"
  end

  create_table "interaction_logs", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.bigint "follow_up_task_id", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_interaction_logs_on_contact_id"
    t.index ["follow_up_task_id"], name: "index_interaction_logs_on_follow_up_task_id"
    t.index ["user_id"], name: "index_interaction_logs_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "event_id", null: false
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "event_id"], name: "index_invitations_on_contact_id_and_event_id", unique: true
    t.index ["contact_id"], name: "index_invitations_on_contact_id"
    t.index ["event_id"], name: "index_invitations_on_event_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "sudo_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sign_in_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sign_in_tokens_on_user_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "contacts", "users", column: "creator_id"
  add_foreign_key "follow_up_tasks", "invitations"
  add_foreign_key "follow_up_tasks", "users"
  add_foreign_key "interaction_logs", "contacts"
  add_foreign_key "interaction_logs", "follow_up_tasks"
  add_foreign_key "interaction_logs", "users"
  add_foreign_key "invitations", "contacts"
  add_foreign_key "invitations", "events"
  add_foreign_key "sessions", "users"
  add_foreign_key "sign_in_tokens", "users"
  add_foreign_key "user_activities", "users"
  add_foreign_key "users", "accounts"
end
