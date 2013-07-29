class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :user_id
      t.attachment :original_audio_file
      t.attachment :downsampled_wav_file

      t.timestamps
    end
  end
end
