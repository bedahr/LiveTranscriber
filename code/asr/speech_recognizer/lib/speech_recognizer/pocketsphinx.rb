require 'open3'
require 'ostruct'
require 'callbackable'

module SpeechRecognizer
  class PocketSphinx

    class Word < OpenStruct
      def tag?
        !! word.to_s.match(/</)
      end
    end

    attr_accessor :file, :pid
    attr_accessor :options

    def initialize(file, options={})
      @file    = file
      @options = options.symbolize_keys
    end

    def run!(&block)
      check!

      callbacks = yield(Callbackable.new)

      debug command

      @word_buffer = []

      # TODO: Currently implementation using pipes is primitive.
      #       If necessary, consider a more advanced solution, e.g. Ruby C bindings
      Open3.popen2(command) do |stdin, stdout, wait_thr|
        @pid = wait_thr.pid

        debug "started"
        callbacks.invoke(:started)

        #stdout.each do |line|
        stdout.each do |line|
          line.strip!

          debug "got line: #{line}"

          callbacks.invoke(:log, line)

          if !line.match(/^\=/)
            raise "unmatched line: #{line}"

          elsif line.match(/^\= utterance_start/)
            callbacks.invoke(:utterance_start)

          elsif line.match(/^\= utterance_end \| (?<distance>\d+)/)
            callbacks.invoke(:utterance_end, $~)

          elsif line.match(/^\= partial_hypothese \| (?<id>\d+?)\: (?<text>.*)/)
            callbacks.invoke(:partial_hypothese, $~)

          elsif line.match(/^\= final_hypothese \| /)
            callbacks.invoke(:final_hypothese, $~)

          elsif line.match(/^\= timed_word \| (?<word>.*?) \| (?<start_timecode>[\d\.]+) (?<end_timecode>[\d\.]+) (?<duration>[\d\.]+)/)
            @word_buffer << Word.new($~.to_hash)

            callbacks.invoke(:timed_word, $~)

          elsif line.match(/^\= continue/)
            data = { :text       => @word_buffer.reject(&:tag?).collect(&:word).join(' '),
                     :start_time => @word_buffer.collect(&:start_timecode).collect(&:to_f).min,
                     :end_time   => @word_buffer.collect(&:end_timecode).collect(&:to_f).max,
                     :words      => @word_buffer.collect(&:all_attributes) }

            callbacks.invoke(:transcript, data)

            @word_buffer = []

            debug "waiting for instructions ..."

            callbacks.invoke(:prompt_to_continue)

            debug "=> got continue instructions. continuing .."
            stdin.puts "\n"

          else
            raise "unknown line: #{line}"
          end
        end

      end
    end

    def kill!
      debug "Killing process: #{pid}"
      Process.kill("KILL", pid)
    end

  private

    def check!
      raise "Could not find #{binary_path}. Did you compile it?" unless File.exists?(binary_path)

      SpeechRecognizer.model_keys.each do |key|
        raise "Speech model not completly defined. Missing key: #{key}" unless options[key]
        raise "Could not find '#{key}' speech model: #{options[key]}" unless File.exists?( File.join(SpeechRecognizer.models_path, key.to_s, options[key]) )
      end
    end

    def binary_path
      File.join(SpeechRecognizer.tools_path, "fatpocketsphinx/fatpocketsphinx_continuous")
    end

    def command
      @command ||= [ binary_path,
                     "-hmm  #{File.join(SpeechRecognizer.models_path, 'hidden_markov_model', options[:hidden_markov_model])}",
                     "-dict #{File.join(SpeechRecognizer.models_path, 'dictionary',          options[:dictionary])}",
                     "-lm   #{File.join(SpeechRecognizer.models_path, 'language_model',      options[:language_model])}",
                     "-infile #{file.path.shell_safe}",
                     "-time yes"
                    ].join(' ')
    end

    def debug(msg)
      STDOUT.puts "[pocketsphinx] #{msg}"
    end

  end
end
