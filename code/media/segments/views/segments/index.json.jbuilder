json.array!(@segments) do |segment|
  json.extract! segment, :recording_id, :start_time, :end_time
  json.url segment_url(segment, format: :json)
end
