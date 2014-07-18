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

ActiveRecord::Schema.define(version: 20140718142819) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "orders", force: true do |t|
    t.string   "plug"
    t.integer  "vk_group_id"
    t.string   "sex"
    t.integer  "age_from"
    t.integer  "age_to"
    t.integer  "vk_city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vk_group_link"
  end

  create_table "sellers", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vk_accounts", force: true do |t|
    t.string   "email"
    t.integer  "vk_id"
    t.integer  "vk_city_id"
    t.string   "sex"
    t.date     "birthdate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "updated",    default: false
  end

  add_index "vk_accounts", ["vk_city_id"], name: "index_vk_accounts_on_vk_city_id", using: :btree
  add_index "vk_accounts", ["vk_id"], name: "index_vk_accounts_on_vk_id", using: :btree

  create_table "vk_cities", force: true do |t|
    t.integer  "vk_city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vk_group_33193420", id: false, force: true do |t|
    t.integer "vk_user_id"
  end

  add_index "vk_group_33193420", ["vk_user_id"], name: "vk_user_id", using: :btree

  create_table "vk_group_60079200", id: false, force: true do |t|
    t.integer "vk_user_id"
  end

  add_index "vk_group_60079200", ["vk_user_id"], name: "vk_user_id", using: :btree

end
