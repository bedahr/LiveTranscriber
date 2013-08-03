class CreateReviewedTranscriptions < ActiveRecord::Migration
  def change
    create_table :reviewed_transcriptions do |t|
      t.integer :user_id
      t.integer :transcription_id
      t.text :text_body
      t.text :html_answer
      t.text :mine_words
      t.text :spotted_mistakes
      t.boolean :has_mines_spotted

      t.timestamps
    end

    add_index :reviewed_transcriptions, :user_id
    add_index :reviewed_transcriptions, :transcription_id
  end
end
