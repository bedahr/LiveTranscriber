require 'sse'

class TalkboxController < ApplicationController
  include ActionController::Live

  before_filter :set_userhash

  def index
    @language = params[:language] || 'en'
  end

  def say
    publish_message(params[:message], params[:userhash])

    render nothing: true
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'

    sse   = SSE.new(response.stream)
    redis = Redis.new

    redis.subscribe("talkbox") do |on|

      on.subscribe do |channel, subscriptions|
        puts "subscribed to: #{channel}"
        publish_message("Entered the chatroom ...", @userhash)
      end

      on.message do |event, data|
        puts "got message: #{data}";
        sse.write(JSON.parse(data), event: 'message')
      end
    end

  rescue IOError

  ensure
    puts "closing ..."

    redis.quit if redis
    sse.close
  end

private

  def publish_message(message, userhash)
    data = { message:message, userhash:userhash, avatar:"http://www.gravatar.com/avatar/#{userhash}?s=15&d=monsterid", time:Time.now }

    puts "publishing message: #{data}"

    $redis.tap { |k| k.publish "talkbox", data.to_json }.quit
  end

  def set_userhash
    @userhash = Digest::MD5.hexdigest( request.remote_ip ).to_s
  end

end
