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

ActiveRecord::Schema.define(version: 20161210170454) do

  create_table "dailywords", force: :cascade do |t|
    t.integer  "User_ID"
    t.string   "Languages"
    t.string   "Word"
    t.string   "Traslation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_dailywords_on_ID"
  end

  create_table "status_updates", force: :cascade do |t|
    t.string   "type_name"
    t.text     "message"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "translations", force: :cascade do |t|
    t.integer  "User_ID"
    t.string   "Languages"
    t.string   "Phrase"
    t.string   "Traslation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_translations_on_ID"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "Phone"
    t.string   "Name"
    t.integer  "Points"
    t.string   "Languages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_users_on_ID"
  end

end
