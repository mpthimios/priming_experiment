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

ActiveRecord::Schema.define(version: 20160625152747) do

  create_table "codes", force: :cascade do |t|
    t.text     "session_id", limit: 65535
    t.string   "mturk_code", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "counts", force: :cascade do |t|
    t.integer  "count",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "session_id", limit: 255
  end

  create_table "movies", force: :cascade do |t|
    t.text     "title",       limit: 65535
    t.text     "description", limit: 65535
    t.string   "url",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "imdb_id",     limit: 255
  end

  create_table "preferences", force: :cascade do |t|
    t.text     "session_id",      limit: 65535
    t.text     "preference",      limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "preference_type", limit: 255
  end

  create_table "ratings", force: :cascade do |t|
    t.string   "movie_id",       limit: 255
    t.integer  "story_id",       limit: 4
    t.string   "session_id",     limit: 255
    t.integer  "rating",         limit: 4
    t.integer  "would_watch",    limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "story_type",     limit: 255
    t.text     "story_keywords", limit: 65535
  end

  create_table "stories", force: :cascade do |t|
    t.text     "title",       limit: 65535
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
