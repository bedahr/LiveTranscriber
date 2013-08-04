class TranscriptionsController < ApplicationController
  has_sticky_params :recording_id

  before_action :set_transcription, only: [:show, :edit, :update, :destroy]

  def index
    @transcriptions = finder.paginate page: params[:page]
  end

  def export
    @transcriptions = finder.to_a

    respond_to do |format|
      format.txt
      format.transcription
    end
  end

  def show
  end

  def new
    @transcription = Transcription.new
  end

  def edit
  end

  def create
    @transcription = @current_user.transcriptions.new(transcription_params)
    @transcription.is_active = true

    respond_to do |format|
      if @transcription.save
        format.html { redirect_to @transcription, notice: 'Transcription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transcription }
      else
        format.html { render action: 'new' }
        format.json { render json: @transcription.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @transcription.update(transcription_params)
        format.html { redirect_to @transcription, notice: 'Transcription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transcription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transcription.destroy
    respond_to do |format|
      format.html { redirect_to transcriptions_url }
      format.json { head :no_content }
      format.js   { head :no_content }
    end
  end

  private

    def finder
      @chain = Transcription.chain
      @chain.includes(:segment).where(segments: { recording_id: params[:recording_id] }) if params[:recording_id]
      @chain.where(segment_id: params[:segment_id]) if params[:segment_id]
      @chain.active if params[:is_active]
      @chain.ordered

      @chain.finder
    end

    def set_transcription
      @transcription = Transcription.find(params[:id])
    end

    def transcription_params
      params.require(:transcription).permit(:segment_id, :html_body, :text_body, :is_active)
    end
end
