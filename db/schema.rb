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

ActiveRecord::Schema[8.0].define(version: 2025_04_24_033612) do
  create_table "leaders", force: :cascade do |t|
    t.string "stat"
    t.string "name1"
    t.string "stat1"
    t.string "name2"
    t.string "stat2"
    t.string "name3"
    t.string "stat3"
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_leaders_on_post_id"
  end

  create_table "pitchers", force: :cascade do |t|
    t.string "name"
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_pitchers_on_post_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_players_on_post_id"
  end

  create_table "pleaders", force: :cascade do |t|
    t.string "stat"
    t.string "name1"
    t.string "stat1"
    t.string "name2"
    t.string "stat2"
    t.string "name3"
    t.string "stat3"
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_pleaders_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id", null: false
    t.index ["post_id"], name: "index_teams_on_post_id"
  end

  add_foreign_key "leaders", "posts"
  add_foreign_key "pitchers", "posts"
  add_foreign_key "players", "posts"
  add_foreign_key "pleaders", "posts"
  add_foreign_key "teams", "posts"
end
