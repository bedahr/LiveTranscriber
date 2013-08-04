class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from 'Exception' , :with => :handle_exception

  layout proc { |controller|
    return 'simple' if controller.request.xhr?
    return 'application'
  }

  before_filter :authenticate_user
  before_filter :set_current_speaker

private

  def set_current_speaker
    @current_speaker = Speaker.find_by_id( session[:current_speaker_id] ) || Speaker.first

    session[:current_speaker_id] = @current_speaker.id
  end

  # TODO: Implement authentication ...
  def authenticate_user
    @current_user ||= User.first
  end

  def handle_exception(exception=nil)
    respond_to do |format|
      format.sse  { raise exception }
      format.vtt  { raise exception }
      format.html { raise exception }
      format.json { render :json => exception.to_json, :status => 500 }
    end
  end

  def self.inherited(klass)
    super
    Core::Extension.append_view!(klass, caller)
  end

  def self.sticky_params
    @sticky_params ||= [ :iframe, :smart_search_initializer, :smart_search_query ]
  end

  def self.has_sticky_params(*args)
    @sticky_params   = sticky_params.concat(args).uniq
  end

  def default_url_options(options={})
    self.class.sticky_params.each_with_object( options ) { |key, memo| memo[key] = params[key] }
  end

end
