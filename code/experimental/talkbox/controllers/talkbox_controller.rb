require 'sse'

class TalkboxController < ApplicationController
  include ActionController::Live

  before_filter :set_userhash

  def index
  end

  def say
    @message  = params[:message]
    @userhash = params[:userhash]
    @html     = render_to_string :partial => 'message', :locals => { message:@message, userhash:@userhash }
    @data     = { message:@message, userhash:@userhash, html:@html, time:Time.now }

    puts "posting message: #{@data}"

    Redis.new.tap { |k| k.publish "talkbox", @data.to_json }.quit

    render nothing: true
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'

    sse   = SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe("talkbox") do |on|

      on.subscribe do |channel, subscriptions|
        puts "subscribed to: #{channel}"
      end

      on.message do |event, data|
        puts "got message: #{data}";

        sse.write(JSON.parse(data), event: 'message')
      end
    end

  rescue IOError
  ensure
    redis.quit if redis
    sse.close
  end

private

  def set_userhash
    @userhash = Digest::MD5.hexdigest( request.remote_ip ).to_s
  end

end
