class Transcription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :segment_id

  validates_presence_of :html_body
  validates_presence_of :text_body

  belongs_to :user
  belongs_to :segment

  has_many :reviewed_transcriptions

  before_validation :initialize_text_body
  before_validation :initialize_duration

  after_save :deactivate_other_transcriptions

  scope :active,  -> { where(is_active: true) }
  scope :ordered, -> { order(:segment_id) }
  scope :today,   -> { where("DAY(created_at) = DAY(NOW())") }

  def raw_words
    text_body.to_s.split(/ /)
  end

private

  def deactivate_other_transcriptions
    self.class.where(segment_id: segment_id).where("id != ?", id).update_all(is_active: false) if is_active
  end

  def initialize_text_body
    self.text_body = Nokogiri::HTML(html_body).text.strip.gsub(" ", " ") # Normalizing nbsp
  end

  def initialize_duration
    self.duration = segment.end_time - segment.start_time if segment && segment.end_time && segment.start_time
  end

end
