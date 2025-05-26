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

ActiveRecord::Schema[7.2].define(version: 2025_05_26_145122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "rooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rooms_on_user_id"
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
    t.index ["user_id", "date"], name: "index_state_calendars_on_user_id_and_date", unique: true
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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

  add_foreign_key "areas", "users"
  add_foreign_key "exchange_diaries", "rooms"
  add_foreign_key "exchange_diaries", "users"
  add_foreign_key "rooms", "users"
  add_foreign_key "state_calendars", "rooms"
  add_foreign_key "state_calendars", "users"
  add_foreign_key "weather_records", "areas"
  add_foreign_key "whiteboards", "rooms"
  add_foreign_key "whiteboards", "users"
end
