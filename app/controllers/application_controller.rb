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
end
