require 'tempfile'

class Recording
  class WordImporter < Recording::AbstractProcessor

    def import!(filename)
      raise "recording already has words" if recording.words.exists?

      File.readlines(filename).collect(&:rstrip).each do |line|
        next unless line.match(/^= timed_word/)

        line.gsub!(/^= timed_word \| /, "")

        tabs = line.split(/\t/)

        start_time, end_time, body, confidence = tabs.shift(4)
        alternatives = []

        tabs.each do |entry|
          score, alternative = entry.split(/ /, 2)
          alternatives << { word: alternative, score: score }
        end

        attributes = { start_time: start_time, end_time: end_time,
                       body: body,
                       confidence: confidence,
                       alternatives: alternatives }

        recording.words.create!(attributes)
      end
    end

  end
end
