module SpeechTraining
  class ModelCloner
    attr_accessor :source_attributes, :destination_attributes, :options

    def initialize(source_attributes, destination_attributes, options={})
      @source_attributes      = source_attributes.symbolize_keys
      @destination_attributes = destination_attributes.symbolize_keys
      @options                = options
    end

    def clone!
      SpeechRecognizer.model_keys.each do |key|
        src = File.join( SpeechRecognizer.models_path, key.to_s, source_attributes[key] )
        dst = File.join( SpeechRecognizer.models_path, key.to_s, destination_attributes[key] )

        # TODO: If file exists, and force is true: rm_r the dst before copying ..
        raise "File exists: #{dst}" if File.exists?(dst) && !options[:force]

        FileUtils.cp_r(src, dst)
      end
    end

  end
end
