module Tool
  class WordImporter < Tool::AbstractProcessor

    def import!(filename)
      import_lines!( File.readlines(filename).collect(&:rstrip) )
    end

    def import_lines!(lines)
      raise "recording already has words" if recording.words.exists?

      lines.each do |line|
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
