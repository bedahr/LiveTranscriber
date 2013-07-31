class AddOptimizedAudioFileToRecordings < ActiveRecord::Migration
  def change
    add_attachment :recordings, :optimized_audio_file
  end
end
