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

ActiveRecord::Schema[7.2].define(version: 2025_07_17_050400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_answers_on_post_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "areas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_areas_on_user_id", unique: true
  end

  create_table "exchange_diaries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_exchange_diaries_on_room_id"
    t.index ["user_id"], name: "index_exchange_diaries_on_user_id"
  end

  create_table "greetings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.string "message", null: false
    t.integer "greeting_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_greetings_on_room_id"
    t.index ["user_id"], name: "index_greetings_on_user_id"
  end

  create_table "invitation_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.string "token", null: false
    t.datetime "used_at"
    t.datetime "expires_at", null: false
    t.integer "invited_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_invitation_tokens_on_room_id"
    t.index ["token"], name: "index_invitation_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_invitation_tokens_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "relationship", null: false
    t.string "custom_relationship"
    t.integer "post_type", null: false
    t.integer "situation", null: false
    t.string "custom_situation"
    t.text "content", null: false
    t.integer "display_name", default: 0, null: false
    t.string "custom_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roommate_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_roommate_lists_on_room_id"
    t.index ["user_id"], name: "index_roommate_lists_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.string "name", null: false
    t.integer "visit_status", null: false
    t.string "address", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_spots_on_room_id"
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "state_calendars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.string "mental_state"
    t.string "physical_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["room_id"], name: "index_state_calendars_on_room_id"
    t.index ["user_id", "room_id", "date"], name: "index_state_calendars_on_user_room_date", unique: true
    t.index ["user_id"], name: "index_state_calendars_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "last_seen_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "weather_records", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.float "temperature"
    t.float "humidity"
    t.string "description"
    t.float "temp_min"
    t.float "temp_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description_en"
    t.index ["area_id"], name: "index_weather_records_on_area_id", unique: true
  end

  create_table "whiteboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_whiteboards_on_room_id"
    t.index ["user_id"], name: "index_whiteboards_on_user_id"
  end

  add_foreign_key "answers", "posts"
  add_foreign_key "answers", "users"
  add_foreign_key "areas", "users"
  add_foreign_key "exchange_diaries", "rooms"
  add_foreign_key "exchange_diaries", "users"
  add_foreign_key "greetings", "rooms"
  add_foreign_key "greetings", "users"
  add_foreign_key "invitation_tokens", "rooms"
  add_foreign_key "invitation_tokens", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "roommate_lists", "rooms"
  add_foreign_key "roommate_lists", "users"
  add_foreign_key "rooms", "users"
  add_foreign_key "spots", "rooms"
  add_foreign_key "spots", "users"
  add_foreign_key "state_calendars", "rooms"
  add_foreign_key "state_calendars", "users"
  add_foreign_key "weather_records", "areas"
  add_foreign_key "whiteboards", "rooms"
  add_foreign_key "whiteboards", "users"
end
