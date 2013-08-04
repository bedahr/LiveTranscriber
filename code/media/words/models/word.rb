class Word < ActiveRecord::Base
  validates_presence_of :recording_id
  validates_presence_of :body

  belongs_to :recording
  belongs_to :segment

  serialize :alternatives

  scope :unassigned, -> { where(segment_id: nil) }
  scope :random,     -> { order("RAND()") }

  before_validation :normalize_body

  include Timecodes

  # TODO: Temporary method as sphinx seems to always suggest 2 words as alternative
  def suggestions
    alternatives ? alternatives.collect { |k| k[:word].split(/ /).first }.uniq : []
  end

  def to_s
    body.to_s.gsub(/\(\d+\)$/, '')
  end

  def tag?
    !! body.to_s.match(/</)
  end

private

  def normalize_body
    self.body = body.strip if body
  end
end
