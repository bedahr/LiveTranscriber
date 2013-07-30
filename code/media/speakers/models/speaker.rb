class Speaker < ActiveRecord::Base
  validates_presence_of   :name
  validates_presence_of   :language_id
  validates_presence_of   :language

  validates_presence_of   :hidden_markov_model, :language_model, :dictionary

  validates_uniqueness_of :name

  belongs_to :language

  acts_as_tree

  before_validation :initialize_models
  before_validation :normalize_model_names

private

  def initialize_models
    return unless parent
    return if base_model_name.blank?

    self.hidden_markov_model = base_model_name
    self.dictionary          = "#{base_model_name}.dict"
    self.language_model      = "#{base_model_name}.lm.DMP"
  end

  def base_model_name
    self.name.to_s.downcase.gsub(/\W/, '_')
  end

  def normalize_model_names
    [ :hidden_markov_model, :language_model, :dictionary ].each do |key|
      self.send(key).gsub!(/[^\w\.]/, '_') if self.send(key)
    end
  end

end
