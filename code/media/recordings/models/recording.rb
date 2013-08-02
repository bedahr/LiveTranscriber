class Recording < ActiveRecord::Base
  validates_presence_of :user_id

  belongs_to :user

  has_many :words
  has_many :segments

  has_attached_file :original_audio_file
  has_attached_file :optimized_audio_file
  has_attached_file :downsampled_wav_file

  before_validation :initialize_original_audio_file_from_url

  attr_accessor :url

  alias_attribute :name, :original_audio_file_file_name

  def create_downsampled_wav_file!
    Recording::Downsampler.new(self).process!
  end

  def create_optimized_audio_file!
    Recording::Optimizer.new(self).process!
  end

  def import_words!(filename)
    Recording::WordImporter.new(self).import!(filename)
  end

  def import_segments!(filename)
    Recording::SegmentImporter.new(self).import!(filename)
  end

private

  def initialize_original_audio_file_from_url
    self.original_audio_file = URI.parse(url) unless url.blank? || original_audio_file.file?
  end

end
