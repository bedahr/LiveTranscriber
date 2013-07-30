json.array!(@languages) do |language|
  json.extract! language, :name, :short_code, :long_code
  json.url language_url(language, format: :json)
end
