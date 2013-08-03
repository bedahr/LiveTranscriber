class Transcription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :segment_id

  validates_presence_of :html_body

  belongs_to :user
  belongs_to :segment

  has_many :reviewed_transcriptions

  before_validation :initialize_text_body
  before_validation :initialize_duration

  scope :today, -> { where("DAY(created_at) = DAY(NOW())") }

  # TODO: Implement this with a boolean flag, e.g. #is_best or #is_active
  def self.best
    all.group_by(&:segment).collect do |segment, transcriptions|
      transcriptions.sort_by(&:created_at).last
    end
  end

  def raw_words
    text_body.to_s.split(/ /)
  end

private

  def initialize_text_body
    self.text_body = Nokogiri::HTML(html_body).text.strip.gsub(" ", " ") # Normalizing nbsp
  end

  def initialize_duration
    self.duration = segment.end_time - segment.start_time if segment && segment.end_time && segment.start_time
  end

end
