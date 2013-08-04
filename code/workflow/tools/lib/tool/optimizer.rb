class Tool
  class Optimizer < Tool::AbstractProcessor

    def process!
      check_recording!
      check_sox!

      system(command) || raise("Optimizing failed: #{command}")

      recording.optimized_audio_file = tempfile
      recording.save

      tempfile.close!
    end

  private

    def tempfile
      @tempfile ||= Tempfile.new(['optimized_recording', '.mp3'])
    end

    def command
      @command ||= [ 'sox',
                     recording.original_audio_file.path.shell_safe,
                     tempfile.path.shell_safe ].join(' ')
    end

  end
end
