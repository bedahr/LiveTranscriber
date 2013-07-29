class WelcomeController < ApplicationController

  def index
    @recording = @current_user.recordings.new
  end
end
