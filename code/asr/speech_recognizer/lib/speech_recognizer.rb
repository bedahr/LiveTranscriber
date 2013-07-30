module SpeechRecognizer

  def model_keys
    [ :hidden_markov_model, :language_model, :dictionary ]
  end

  def models_path
    File.join(Rails.root, "speech_recognition", "models")
  end

  def tools_path
    File.join(Rails.root, "speech_recognition", "tools")
  end

  extend self

end
