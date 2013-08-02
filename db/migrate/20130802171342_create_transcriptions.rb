class CreateTranscriptions < ActiveRecord::Migration
  def change
    create_table :transcriptions do |t|
      t.integer :user_id
      t.integer :segment_id
      t.text :html_body
      t.text :text_body

      t.timestamps
    end

    add_index :transcriptions, :user_id
    add_index :transcriptions, :segment_id
  end
end
