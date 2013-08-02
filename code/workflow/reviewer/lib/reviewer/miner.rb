module Reviewer
  class Miner

    attr_accessor :transcriptions

    def initialize(transcriptions)
      @transcriptions = transcriptions
    end

    def add_mines!(mine_words, options={})
      available_mines = mine_words.dup
      max             = options[:max] || raise('no max given')

      transcriptions.shuffle.first(max).each do |transcription|
        mine  = available_mines.shift || raise('no more mines left')
        words = transcription.text_body.split(/ /)

        words.insert( rand(words.size), mine.body)

        transcription.text_body_with_mines = words.join(' ')
      end

      transcriptions.each { |k| k.text_body_with_mines ||= k.text_body }
    end

  end
end
