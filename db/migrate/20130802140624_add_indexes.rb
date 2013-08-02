class AddIndexes < ActiveRecord::Migration
  def change
    add_index :recordings, :user_id
    add_index :segments,   :recording_id
    add_index :speakers,   :language_id
    add_index :words,      :recording_id
    add_index :words,      :segment_id
  end
end
