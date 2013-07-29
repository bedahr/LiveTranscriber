class Recording < ActiveRecord::Base
  validates_presence_of :user_id

  belongs_to :user

  has_attached_file :original_audio_file
  has_attached_file :downsampled_wav_file

  before_validation :initialize_original_audio_file_from_url

  attr_accessor :url

  # TODO: original_audio_file should be normalized to ensure that timecodes match
  #       Some MP3 encoders mess timecodes up
  # TODO: Temporary alias for original_audio_file, unless optimization is implemented
  alias :optimized_audio_file :original_audio_file

  alias_attribute :name, :original_audio_file_file_name

  def create_downsampled_wav_file!
    Recording::Downsampler.new(self).process!
  end

private

  def initialize_original_audio_file_from_url
    self.original_audio_file = URI.parse(url) unless url.blank? || original_audio_file.file?
  end

end
