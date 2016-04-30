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

ActiveRecord::Schema.define(version: 20160417104209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "answers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "question_message_id"
    t.text     "question_text"
    t.integer  "answer_message_id"
    t.text     "answer_text"
    t.string   "url"
    t.jsonb    "properties"
    t.datetime "asked_at"
    t.datetime "answered_at"
    t.integer  "asked_by"
    t.datetime "created_at",          :null=>false
    t.datetime "updated_at",          :null=>false
    t.string   "property_name"
  end

  create_table "channels", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created"
    t.string   "creator"
    t.boolean  "is_archived"
    t.boolean  "is_member"
    t.integer  "num_members"
    t.integer  "team_id"
    t.jsonb    "slack_data"
    t.jsonb    "properties"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.string   "free_trial_length"
    t.datetime "created_at",        :null=>false
    t.datetime "updated_at",        :null=>false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "channel_uid"
    t.integer  "channel_id"
    t.string   "team_uid"
    t.integer  "team_id"
    t.text     "text"
    t.string   "ts"
    t.datetime "timestamp"
    t.string   "message_type"
    t.string   "message_subtype"
    t.string   "user_uid"
    t.integer  "user_id"
    t.json     "properties"
    t.json     "slack_data"
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.float    "price"
    t.string   "interval"
    t.text     "features"
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
  end

  create_table "presences", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "team_uid"
    t.jsonb    "active_ids"
    t.jsonb    "active_uids"
    t.jsonb    "away_ids"
    t.jsonb    "away_uids"
    t.jsonb    "slack_api_data"
    t.datetime "checked_at"
    t.datetime "created_at",     :null=>false
    t.datetime "updated_at",     :null=>false
    t.index :name=>"presences_creation_day_index", :expression=>"date_trunc('day'::text, created_at)"
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "team_id"
    t.text     "text"
    t.text     "response"
    t.integer  "priority"
    t.integer  "author_id"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "plan_id"
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.float    "current_price"
    t.integer  "team_id"
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "domain"
    t.string   "email_domain"
    t.string   "bot_user_id"
    t.string   "bot_access_token"
    t.json     "slack_data"
    t.datetime "created_at",       :null=>false
    t.datetime "updated_at",       :null=>false
    t.integer  "user_id"
    t.string   "user_uid"
    t.boolean  "is_active",        :default=>true, :null=>false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                      :null=>false
    t.datetime "updated_at",                      :null=>false
    t.integer  "role"
    t.json     "slack_auth_data"
    t.json     "slack_api_data"
    t.json     "slack_reactions_data"
    t.datetime "slack_auth_data_updated_at"
    t.datetime "slack_api_data_updated_at"
    t.datetime "slack_reactions_data_updated_at"
    t.string   "team_uid"
    t.string   "team_name"
    t.string   "team_domain"
    t.datetime "last_activity_at"
    t.json     "channels"
    t.json     "emoji"
    t.integer  "photo_score"
    t.jsonb    "admin_welcome_messages"
    t.jsonb    "public_welcome_message"
    t.jsonb    "private_welcome_messages"
    t.integer  "score"
    t.jsonb    "clearbit_data"
  end

end
