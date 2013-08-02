class ReviewerController < ApplicationController
  before_filter :set_recording

  def index
    per_page = 5 # TODO: Allowing user to set this might break mining ..

    raise "Recording is not processed" unless @recording.processed?

    @segments       = @recording.segments.includes(:words).paginate :per_page => per_page, :page => params[:page]
    @transcriptions = @current_user.transcriptions.includes(:segment).where(:segment_id => @segments.collect(&:id)).best

    raise "missing transcripts" unless ( @segments - @transcriptions.collect(&:segment).uniq ).empty?

    @mine_words = @recording.words.where("body NOT IN(?)", @segments.collect(&:words).flatten.collect(&:body) ).random.limit(@transcriptions.size)

    Reviewer::Miner.new(@transcriptions).add_mines!(@mine_words, :max => 1)
  end

private

  def set_recording
    @recording = Recording.find(params[:id])
  end

end
