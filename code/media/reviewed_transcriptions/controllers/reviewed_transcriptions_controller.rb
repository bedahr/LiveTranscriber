class ReviewedTranscriptionsController < ApplicationController
  before_action :set_reviewed_transcription, only: [:show, :edit, :update, :destroy]

  def index
    @chain = ReviewedTranscription.chain
    @chain.includes(:transcription => :segment).where(segments: { recording_id: params[:recording_id] }) if params[:recording_id]

    @reviewed_transcriptions = @chain.finder.paginate page: params[:page]
  end

  def show
  end

  def new
    @reviewed_transcription = ReviewedTranscription.new
  end

  def edit
  end

  def create
    @reviewed_transcription = ReviewedTranscription.new(reviewed_transcription_params)

    respond_to do |format|
      if @reviewed_transcription.save
        format.html { redirect_to @reviewed_transcription, notice: 'Reviewed transcription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reviewed_transcription }
      else
        format.html { render action: 'new' }
        format.json { render json: @reviewed_transcription.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @reviewed_transcription.update(reviewed_transcription_params)
        format.html { redirect_to @reviewed_transcription, notice: 'Reviewed transcription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reviewed_transcription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reviewed_transcription.destroy
    respond_to do |format|
      format.html { redirect_to reviewed_transcriptions_url }
      format.json { head :no_content }
    end
  end

  private

    def set_reviewed_transcription
      @reviewed_transcription = ReviewedTranscription.find(params[:id])
    end

    def reviewed_transcription_params
      params.require(:reviewed_transcription).permit(:html_answer)
    end
end
