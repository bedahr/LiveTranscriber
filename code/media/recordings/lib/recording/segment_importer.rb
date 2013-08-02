require 'tempfile'

class Recording
  class SegmentImporter < Recording::AbstractProcessor

    def import!(filename)
      import_lines!( File.readlines(filename).collect(&:rstrip) )
    end

    def import_lines!(lines)
      raise "recording already has segments" if recording.segments.exists?

      lines.reject(&:blank?).each do |line|
        start_time, end_time, body = line.split(/\t/, 3)

        attributes = { start_time: start_time, end_time: end_time, body: body }

        recording.segments.create!(attributes)
      end
    end

  end
end
