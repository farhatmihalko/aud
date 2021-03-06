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

ActiveRecord::Schema.define(:version => 20130910184024) do

  create_table "adverts", :force => true do |t|
<<<<<<< HEAD
    t.integer  "counter"
    t.string   "company"
=======
    t.string   "company"
    t.integer  "counter"
    t.integer  "place"
>>>>>>> e602bf29afc1bd8a2695e49043a7b0921be61c49
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "addsloader"
    t.string   "anchor"
<<<<<<< HEAD
    t.integer  "place"
    t.string   "banner"
=======
>>>>>>> e602bf29afc1bd8a2695e49043a7b0921be61c49
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "banner"
  end

  create_table "words", :force => true do |t|
    t.string   "name"
    t.string   "indexed_name"
    t.text     "definition"
    t.string   "language"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "words", ["indexed_name"], :name => "index_words_on_indexed_name"

end
