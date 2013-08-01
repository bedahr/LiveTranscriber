json.array!(@words) do |word|
  json.extract! word, :recording_id, :body, :start_time, :end_time, :confidence
  json.url word_url(word, format: :json)
end
