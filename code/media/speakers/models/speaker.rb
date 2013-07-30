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
    return if self.name.blank?

    model_keys.each do |key|
      self.send("#{key}=", self.name.to_s.downcase.gsub(/\W/, '_') ) if self.send(key).blank?
    end
  end

  def normalize_model_names
    model_keys.each do |key|
      self.send(key).gsub!(/[^\w\.]/, '_') if self.send(key)
    end
  end

  def model_keys
    [ :hidden_markov_model, :language_model, :dictionary ]
  end
end
