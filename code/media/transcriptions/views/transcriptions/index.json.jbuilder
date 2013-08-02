json.array!(@transcriptions) do |transcription|
  json.extract! transcription, :user_id, :segment_id, :html_body, :text_body
  json.url transcription_url(transcription, format: :json)
end
