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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130113102546) do

  create_table "expenses", :force => true do |t|
    t.integer  "household_id"
    t.integer  "roommate_id"
    t.boolean  "paid_in"
    t.boolean  "split_evenly"
    t.decimal  "value"
    t.boolean  "settled"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "note"
    t.string   "item_name"
    t.time     "deleted_at"
    t.integer  "created_by_roommate_id"
  end

  create_table "households", :force => true do |t|
    t.string   "nickname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "roommate_id"
    t.string   "fb_id"
    t.boolean  "open"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "request_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "axis_id"
    t.string   "axis_type"
    t.string   "action"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "roommate_id"
  end

  create_table "roommate_expenses", :force => true do |t|
    t.integer  "expense_id"
    t.integer  "roommate_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "included",    :default => true
  end

  create_table "roommate_notifications", :force => true do |t|
    t.integer  "roommate_id"
    t.integer  "notification_id"
    t.time     "seen_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "roommates", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fb_id"
    t.integer  "household_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "state"
    t.string   "oauth_token"
    t.date     "oauth_expiration"
  end

end
