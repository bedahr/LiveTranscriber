class TranscriptionsController < ApplicationController
  before_action :set_transcription, only: [:show, :edit, :update, :destroy]

  def index
    @transcriptions = Transcription.all
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
    end
  end

  private

    def set_transcription
      @transcription = Transcription.find(params[:id])
    end

    def transcription_params
      params.require(:transcription).permit(:segment_id, :html_body, :text_body)
    end
end
