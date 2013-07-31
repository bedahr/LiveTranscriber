class Speaker < ActiveRecord::Base
  validates_presence_of   :name
  validates_presence_of   :language_id
  validates_presence_of   :language

  validates_presence_of   :hidden_markov_model, :language_model, :dictionary

  validates_uniqueness_of :name

  belongs_to :language

  acts_as_tree

  before_validation :initialize_model_settings
  before_validation :normalize_model_names

  scope :ordered, -> { order(:parent_id) }

  def base_model?
    parent_id.nil?
  end

  def speech_model_initialized?
    base_model? || File.directory?( File.join(SpeechRecognizer.models_path, "hidden_markov_model/", hidden_markov_model ))
  end

  def initialize_speech_model!(options={})
    raise "Can not initialize a base model" if base_model?

    SpeechTraining::ModelCloner.new(self.parent.attributes, self.attributes, options).clone!
  end

private

  def initialize_model_settings
    return unless parent
    return if base_model_name.blank?

    SpeechRecognizer.model_keys.each { |k| self.send("#{k}=", nil) if self.send(k).blank? }

    self.hidden_markov_model ||= base_model_name
    self.dictionary          ||= "#{base_model_name}.dict"
    self.language_model      ||= "#{base_model_name}.lm.DMP"
  end

  def base_model_name
    self.name.to_s.downcase.gsub(/\W/, '_')
  end

  def normalize_model_names
    SpeechRecognizer.model_keys.each do |key|
      self.send(key).gsub!(/[^\w\.]/, '_') if self.send(key)
    end
  end

end
