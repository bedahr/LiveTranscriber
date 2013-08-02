class Segment < ActiveRecord::Base
  validates_presence_of :recording_id

  belongs_to :recording

  has_many :words

  include Timecodes

  def assign_words!
    recording.words.where("start_time >= ? AND start_time <= ?", start_time, end_time).each do |word|
      word.update_attribute(:segment_id, id)
    end
  end
end
