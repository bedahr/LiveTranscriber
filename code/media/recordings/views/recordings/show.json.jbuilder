json.extract! @recording, :user_id, :name, :original_audio_file, :downsampled_wav_file, :created_at, :updated_at
json.url recording_url(@recording)
