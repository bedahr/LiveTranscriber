class ReviewedTranscription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :transcription_id

  validates_uniqueness_of :transcription_id, :scope => :user_id

  belongs_to :user
  belongs_to :transcription

  serialize :mine_words
  serialize :spotted_mistakes

  delegate :segment, to: :transcription

  scope :pending,  -> { where(html_answer: nil) }
  scope :accepted, -> { where(has_mines_spotted: true)  }
  scope :rejected, -> { where(has_mines_spotted: false) }

  def self.find_or_create_with_mines!(transcriptions, mine_words, options={})
    reviewed_transcriptions  = where(transcription_id: transcriptions.collect(&:id)).all
    reviewed_transcriptions += ( transcriptions - reviewed_transcriptions.collect(&:transcription) ).collect { |k| new(transcription: k) }

    Reviewer::Miner.new( reviewed_transcriptions.select(&:new_record?) ).add_mines!(mine_words, options)

    reviewed_transcriptions.each { |k| k.save! if k.new_record? }
  end
end
