class Tool
  class AbstractProcessor

    attr_accessor :recording, :options

    def initialize(recording, options={})
      @recording = recording
      @options   = options
    end

  private

    def check_recording!
      raise "No original audio file" unless recording.original_audio_file.try(:file?)
    end

    def check_sox!
      raise "Could not confirm SoX installation" unless `sox`.to_s.match(/sox/)
    end

  end
end
