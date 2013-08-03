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

ActiveRecord::Schema.define(version: 20130803092233) do

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

  add_index "recordings", ["user_id"], name: "index_recordings_on_user_id", using: :btree

  create_table "reviewed_transcriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "transcription_id"
    t.text     "text_body"
    t.text     "html_answer"
    t.text     "mine_words"
    t.text     "spotted_mistakes"
    t.boolean  "has_mines_spotted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_mines_indirectly_spotted"
    t.boolean  "has_mistakes"
  end

  add_index "reviewed_transcriptions", ["transcription_id"], name: "index_reviewed_transcriptions_on_transcription_id", using: :btree
  add_index "reviewed_transcriptions", ["user_id"], name: "index_reviewed_transcriptions_on_user_id", using: :btree

  create_table "segments", force: true do |t|
    t.integer  "recording_id"
    t.float    "start_time"
    t.float    "end_time"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "segments", ["recording_id"], name: "index_segments_on_recording_id", using: :btree

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

  add_index "speakers", ["language_id"], name: "index_speakers_on_language_id", using: :btree

  create_table "transcriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "segment_id"
    t.text     "html_body"
    t.text     "text_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transcriptions", ["segment_id"], name: "index_transcriptions_on_segment_id", using: :btree
  add_index "transcriptions", ["user_id"], name: "index_transcriptions_on_user_id", using: :btree

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

  add_index "words", ["recording_id"], name: "index_words_on_recording_id", using: :btree
  add_index "words", ["segment_id"], name: "index_words_on_segment_id", using: :btree

end
