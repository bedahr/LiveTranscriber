class Segment < ActiveRecord::Base
  validates_presence_of :recording_id

  belongs_to :recording

  has_many :words

  # TODO: Move this out into a concern/
  def start_timecode
    @start_timecode ||= Time.at(start_time).strftime('%M:%S.%3N')
  end

  # TODO: Move this out into a concern/
  def end_timecode
    @end_timecode ||= Time.at(end_time).strftime('%M:%S.%3N')
  end

  def assign_words!
    recording.words.where("start_time >= ? AND start_time <= ?", start_time, end_time).each do |word|
      word.update_attribute(:segment_id, id)
    end
  end
end
