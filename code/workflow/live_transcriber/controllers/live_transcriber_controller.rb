require 'sse'
require 'speech_recognizer/pocketsphinx'

class LiveTranscriberController < ApplicationController
  #include ActionController::Live

  before_filter :set_recording

  def index
    @recording.create_downsampled_wav_file! unless @recording.downsampled_wav_file.file?
    @recording.create_optimized_audio_file! unless @recording.optimized_audio_file.file?

    @segments = @recording.segments.paginate :per_page => ( params[:per_page] || 5 ), :page => params[:page]
  end

  def segments
  end

  def realtime
    index
  end

  # TODO: Implement saving of transcription
  def submit
    notify_speech_recognizer
  end

  # TODO: Implement saving of skip (might be useful to detect 'difficult' clips)
  def skip
    notify_speech_recognizer
  end

  def events
   response.headers['Content-Type'] = 'text/event-stream'

   sse = SSE.new(response.stream)

   raise "No current_speaker defined" unless @current_speaker

   speech_recognizer = SpeechRecognizer::PocketSphinx.new(@recording.downsampled_wav_file, @current_speaker.attributes)

   speech_recognizer.run! do |on|

     on.started do
       sse.write({}, :event => 'started')
     end

     on.transcript do |data|
       sse.write(data, :event => 'transcript')
     end

     on.partial_hypothese do |data|
       sse.write(data, :event => 'partial_hypothese')
     end

     on.log do |line|
       sse.write({ :line => line }, :event => 'log' )
     end

     on.prompt_to_continue do
       debug "Redis: Subscribing: #{redis_channel}"

       redis = Redis.new

       redis.subscribe(redis_channel) do |on|
         on.subscribe do |channel, subscriptions|
           debug "Redis: Subscribed: #{channel} #{subscriptions}"
         end

         on.message do |channel, msg|
           if msg == 'continue'
             debug "Redis: Got 'continue' message - Continuing: #{channel} #{msg}"
             redis.unsubscribe
           end
         end
       end

     end

   end

  rescue
    sse.write( { :data => $!.inspect }, :event => 'terminated' )

  ensure
    speech_recognizer.kill! rescue nil

    sse.write( { :terminated => true }, :event => 'terminated' )

    sse.close
  end

private

  def notify_speech_recognizer
    debug "Redis: Sending 'continue' notification"
    Redis.new.tap { |k| k.publish(redis_channel, "continue") }.quit

    render :text => "OK"
  end

  def debug(msg)
    STDOUT.puts msg
  end

  def set_recording
    @recording = Recording.find(params[:id])
  end

  def redis_channel
    "live_transcriber:#{@recording.id}"
  end

end
