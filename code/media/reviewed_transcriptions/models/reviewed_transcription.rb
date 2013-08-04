class ReviewedTranscription < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :transcription_id

  validates_uniqueness_of :transcription_id, scope: :user_id

  belongs_to :user
  belongs_to :transcription

  serialize :mine_words
  serialize :spotted_mistakes

  delegate :segment, to: :transcription

  scope :pending,  -> { where(html_answer: nil) }
  scope :accepted, -> { where("has_mines_spotted IS TRUE or has_mines_indirectly_spotted IS TRUE") }
  scope :rejected, -> { where("has_mines_spotted IS FALSE") }

  scope :today, -> { where("DAY(created_at) = DAY(NOW())") }

  after_validation :initialize_duration

  after_validation :process_answer
  after_validation :process_mines

  def current_body
    html_answer ? html_answer : text_body
  end

  def accepted?
    has_mines_spotted == true || has_mines_indirectly_spotted == true
  end

  def rejected?
    has_mines_spotted == false
  end

  def has_mines?
    mine_words && mine_words.any?
  end

  def mines_detected?
    ( mine_words - ( spotted_mistakes || [] ) ).none?
  end

  def answered?
    !html_answer.blank?
  end

private

  def initialize_duration
    self.duration = transcription.try(:duration)
  end

  def process_answer
    return unless answered?

    self.spotted_mistakes = []

    root = Nokogiri::HTML(html_answer)
    root.search(".highlighted").each do |highlight|
      self.spotted_mistakes << highlight.text
    end

    self.has_mistakes = true if ( self.spotted_mistakes - ( mine_words || [] ) ).any?
  end

  def process_mines
    self.has_mines_spotted = mines_detected? if answered? && has_mines?
  end

  def self.find_or_create_with_mines!(transcriptions, mine_words, options={})
    reviewed_transcriptions  = where(transcription_id: transcriptions.collect(&:id)).all
    reviewed_transcriptions += ( transcriptions - reviewed_transcriptions.collect(&:transcription) ).collect { |k| new(transcription: k) }

    Reviewer::Miner.new( reviewed_transcriptions.select(&:new_record?) ).add_mines!(mine_words, options)

    reviewed_transcriptions.each { |k| k.save! if k.new_record? }
  end
end
