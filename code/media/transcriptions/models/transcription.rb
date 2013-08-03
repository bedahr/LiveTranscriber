class Transcription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :segment_id

  validates_presence_of :html_body

  belongs_to :user
  belongs_to :segment

  has_many :reviewed_transcriptions

  before_validation :initialize_text_body

  # TODO: Implement this with a boolean flag, e.g. #is_best or #is_active
  def self.best
    all.group_by(&:segment).collect do |segment, transcriptions|
      transcriptions.sort_by(&:created_at).last
    end
  end

private

  def initialize_text_body
    self.text_body = Nokogiri::HTML(html_body).text.strip
  end

end
