class Transcription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :segment_id

  validates_presence_of :html_body

  belongs_to :user
  belongs_to :segment

  before_validation :initialize_text_body

private

  def initialize_text_body
    self.text_body = Nokogiri::HTML(html_body).text.strip
  end

end
