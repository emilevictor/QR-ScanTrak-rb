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

ActiveRecord::Schema.define(:version => 20120921033930) do

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "organisation"
    t.integer  "maxNumberOfPlayers"
    t.text     "contactDetails"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "password"
    t.date     "paymentExpires"
    t.boolean  "requiresPassword"
  end

  create_table "games_users", :id => false, :force => true do |t|
    t.integer "game_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "games_users", ["game_id", "user_id"], :name => "index_games_users_on_game_id_and_user_id", :unique => true

  create_table "scans", :force => true do |t|
    t.integer  "team_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "comment"
    t.integer  "user_id"
  end

  add_index "scans", ["tag_id", "team_id"], :name => "index_scans_on_tag_id_and_team_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "uniqueUrl"
    t.string   "QRCode"
    t.text     "quizQuestion"
    t.string   "quizAnswer"
    t.text     "content"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "address"
    t.integer  "createdBy"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.integer  "points"
    t.string   "qr_code_uid"
    t.string   "qr_code_name"
  end

  create_table "tags_teams", :id => false, :force => true do |t|
    t.integer "team_id"
    t.integer "tag_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "password"
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "team_creator_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "team_id"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                  :default => false
    t.text     "comments"
    t.integer  "tag_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
