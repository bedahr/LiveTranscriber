class Tool
  class Downsampler < Tool::AbstractProcessor

    def initialize(*args)
      super

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

  end
end
