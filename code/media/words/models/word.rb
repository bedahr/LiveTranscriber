class Word < ActiveRecord::Base
  validates_presence_of :recording_id
  validates_presence_of :body

  belongs_to :recording

  def start_timecode
    @start_timecode ||= Time.at(start_time).strftime('%M:%S.%3N')
  end

  def end_timecode
    @end_timecode ||= Time.at(end_time).strftime('%M:%S.%3N')
  end

  def to_s
    body.to_s.gsub(/\(\d+\)$/, '')
  end

  def tag?
    !! body.to_s.match(/</)
  end
end
