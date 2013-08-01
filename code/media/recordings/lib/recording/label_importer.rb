require 'tempfile'

class Recording
  class LabelImporter < Recording::AbstractProcessor

    def import!(filename)
      raise "recording already has words" if recording.words.exists?

      File.readlines(filename).collect(&:rstrip).each do |line|
        start_time, end_time, word, confidence = line.split(/\t/, 4)

        recording.words.create!(start_time: start_time, end_time: end_time, body: word, confidence: confidence)
      end
    end

  end
end
