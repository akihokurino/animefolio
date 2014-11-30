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

ActiveRecord::Schema.define(version: 20141129173547) do

  create_table "anime_maps", force: true do |t|
    t.string   "week"
    t.string   "title"
    t.string   "now_episode"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: true do |t|
    t.integer  "film_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "films", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "thumbnail"
    t.string   "first_letter"
    t.boolean  "recent"
    t.boolean  "popular"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_new",       default: false
  end

  create_table "links", force: true do |t|
    t.integer  "content_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
