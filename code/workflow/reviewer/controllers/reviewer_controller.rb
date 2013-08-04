class ReviewerController < ApplicationController
  before_filter :set_recording

  def index
    raise "Recording is not processed" unless @recording.processed?

    @segments       = @recording.segments.includes(:words).paginate page: params[:page], per_page: 5
    @transcriptions = @current_user.transcriptions.includes(:segment).where(:segment_id => @segments.collect(&:id)).active

    raise "missing transcripts" unless ( @segments - @transcriptions.collect(&:segment).uniq ).empty?

    @mine_words = @recording.words.where("body NOT IN(?)", @transcriptions.collect(&:raw_words).flatten.uniq ).random.limit(@transcriptions.size)

    @reviewed_transcriptions = @current_user.reviewed_transcriptions.find_or_create_with_mines!(@transcriptions, @mine_words, :max => 1)
  end

  def save
    @reviewed_transcriptions = []

    params[:reviewed_transcriptions].each do |id, html|
      @reviewed_transcriptions << @current_user.reviewed_transcriptions.find(id).tap { |k| k.update_attributes(html_answer: html) }
    end

    if @reviewed_transcriptions.select(&:has_mines?).all?(&:mines_detected?)
      @reviewed_transcriptions.reject(&:has_mines?).each do |reviewed_transcription|
        reviewed_transcription.update_attribute(:has_mines_indirectly_spotted, true)
      end
    end

    render nothing: true
  end

private

  def set_recording
    @recording = Recording.find(params[:id])
  end

end
