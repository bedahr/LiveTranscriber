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

ActiveRecord::Schema.define(version: 20130802133959) do

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "short_code"
    t.string   "long_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recordings", force: true do |t|
    t.integer  "user_id"
    t.string   "original_audio_file_file_name"
    t.string   "original_audio_file_content_type"
    t.integer  "original_audio_file_file_size"
    t.datetime "original_audio_file_updated_at"
    t.string   "downsampled_wav_file_file_name"
    t.string   "downsampled_wav_file_content_type"
    t.integer  "downsampled_wav_file_file_size"
    t.datetime "downsampled_wav_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "optimized_audio_file_file_name"
    t.string   "optimized_audio_file_content_type"
    t.integer  "optimized_audio_file_file_size"
    t.datetime "optimized_audio_file_updated_at"
  end

  create_table "segments", force: true do |t|
    t.integer  "recording_id"
    t.float    "start_time"
    t.float    "end_time"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "speakers", force: true do |t|
    t.integer  "parent_id"
    t.integer  "language_id"
    t.string   "name"
    t.string   "hidden_markov_model"
    t.string   "language_model"
    t.string   "dictionary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", force: true do |t|
    t.integer  "recording_id"
    t.string   "body"
    t.float    "start_time"
    t.float    "end_time"
    t.float    "confidence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "segment_id"
    t.text     "alternatives"
  end

end
