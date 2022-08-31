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

ActiveRecord::Schema[7.0].define(version: 2022_08_30_042532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "distancepredictions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "fight_id"
    t.boolean "distance"
    t.float "line"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "wager"
    t.boolean "is_correct", default: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.string "category"
  end

  create_table "fighters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fights", force: :cascade do |t|
    t.integer "event_id"
    t.integer "red_id"
    t.integer "blue_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "placement"
  end

  create_table "methodpredictions", force: :cascade do |t|
    t.integer "fight_id"
    t.integer "user_id"
    t.integer "fighter_id"
    t.integer "method"
    t.float "line"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "wager"
    t.boolean "is_correct", default: false
  end

  create_table "odds", force: :cascade do |t|
    t.integer "fight_id"
    t.float "red_any"
    t.float "red_knockout"
    t.float "red_submission"
    t.float "red_decision"
    t.float "blue_any"
    t.float "blue_knockout"
    t.float "blue_submission"
    t.float "blue_decision"
    t.float "yes_decision"
    t.float "no_decision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "fight_id"
    t.integer "fighter_id"
    t.integer "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_event_budgets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "winnings", default: 0
    t.integer "wagered", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.integer "points", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
