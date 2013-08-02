class Word < ActiveRecord::Base
  validates_presence_of :recording_id
  validates_presence_of :body

  belongs_to :recording
  belongs_to :segment

  serialize :alternatives

  # TODO: Temporary method as sphinx seems to always suggest 2 words as alternative
  def suggestions
    alternatives.collect { |k| k[:word].split(/ /).first }.uniq
  end

  # TODO: Move this out into a concern/
  def start_timecode
    @start_timecode ||= Time.at(start_time).strftime('%M:%S.%3N')
  end

  # TODO: Move this out into a concern/
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
