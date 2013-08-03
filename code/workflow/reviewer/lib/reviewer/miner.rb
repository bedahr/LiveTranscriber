module Reviewer
  class Miner

    attr_accessor :reviewed_transcriptions

    def initialize(reviewed_transcriptions)
      @reviewed_transcriptions = reviewed_transcriptions
    end

    def add_mines!(mine_words, options={})
      available_mines = mine_words.dup
      max             = options[:max] || raise('no max given')

      reviewed_transcriptions.shuffle.first(max).each do |reviewed_transcription|
        mine  = available_mines.shift || raise('no more mines left')
        words = reviewed_transcription.transcription.text_body.split(/ /)

        words.insert( rand(words.size), mine.body)

        reviewed_transcription.mine_words ||= []
        reviewed_transcription.mine_words << mine.body

        reviewed_transcription.text_body   = words.join(' ')
      end

      reviewed_transcriptions.each { |k| k.text_body ||= k.transcription.text_body }
    end

  end
end
