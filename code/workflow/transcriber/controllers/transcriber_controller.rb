class TranscriberController < ApplicationController
  before_filter :set_recording

  def index
    raise "Recording is not processed" unless @recording.processed?

    @segments       = @recording.segments.paginate :per_page => ( params[:per_page] || 5 ), :page => params[:page]
    @transcriptions = @current_user.transcriptions.includes(:segment).where(:segment_id => @segments.collect(&:id))
  end

  def segments
  end

  def words
  end

private

  def set_recording
    @recording = Recording.find(params[:id])
  end

end
