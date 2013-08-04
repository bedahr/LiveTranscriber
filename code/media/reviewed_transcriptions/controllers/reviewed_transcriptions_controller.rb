class ReviewedTranscriptionsController < ApplicationController

  def index
    @chain = ReviewedTranscription.chain
    @chain.includes(transcription: :segment).where(segments: { recording_id: params[:recording_id] }) if params[:recording_id]

    @reviewed_transcriptions = @chain.finder.paginate page: params[:page]
  end

end
