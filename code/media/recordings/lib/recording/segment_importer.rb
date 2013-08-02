require 'tempfile'

class Recording
  class SegmentImporter < Recording::AbstractProcessor

    def import!(filename)
      raise "recording already has segments" if recording.segments.exists?

      File.readlines(filename).collect(&:rstrip).each do |line|
        start_time, end_time, body = tabs.shift(4)

        attributes = { start_time: start_time, end_time: end_time,
                       body: body
                     }

        recording.segments.create!(attributes)
      end
    end

  end
end
