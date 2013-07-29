require 'tempfile'

class Recording
  class Downsampler

    attr_accessor :recording, :options

    def initialize(recording, options={})
      @recording = recording
      @options   = options

      @options[:sample_rate] ||= 16_000
      @options[:channels]    ||= 1
    end

    def process!
      check_recording!
      check_sox!

      system(command) || raise("Downsampling failed: #{command}")

      recording.downsampled_wav_file = tempfile
      recording.save

      tempfile.close!
    end

  private

    def tempfile
      @tempfile ||= Tempfile.new(['downsampled_recording', '.wav'])
    end

    def command
      @command ||= [ 'sox',
                     recording.original_audio_file.path.shell_safe,
                     "-r #{options[:sample_rate]}",
                     "-c #{options[:channels]}",
                     tempfile.path.shell_safe ].join(' ')
    end

    def check_recording!
      raise "No original audio file" unless recording.original_audio_file.try(:file?)
    end

    def check_sox!
      raise "Could not confirm SoX installation" unless `sox`.match(/sox/)
    end

  end
end
