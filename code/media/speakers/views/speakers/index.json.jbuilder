json.array!(@speakers) do |speaker|
  json.extract! speaker, :language_id, :name, :hidden_markov_model, :language_model, :dictionary
  json.url speaker_url(speaker, format: :json)
end
