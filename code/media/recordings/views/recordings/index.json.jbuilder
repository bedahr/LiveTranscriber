json.array!(@recordings) do |recording|
  json.extract! recording, :user_id, :name
  json.url recording_url(recording, format: :json)
end
