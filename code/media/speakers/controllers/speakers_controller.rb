class SpeakersController < ApplicationController
  before_action :set_speaker, only: [:show, :edit, :update, :destroy, :activate]

  def index
    @speakers = Speaker.all
  end

  def show
  end

  def new
    @speaker = Speaker.new(speaker_params)
  end

  def edit
  end

  def activate
    session[:current_speaker_id] = @speaker
    redirect_to speakers_path
  end

  def create
    @speaker = Speaker.new(speaker_params)

    respond_to do |format|
      if @speaker.save
        format.html { redirect_to @speaker, notice: 'Speaker was successfully created.' }
        format.json { render action: 'show', status: :created, location: @speaker }
      else
        format.html { render action: 'new' }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @speaker.update(speaker_params)
        format.html { redirect_to @speaker, notice: 'Speaker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @speaker.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @speaker.destroy
    respond_to do |format|
      format.html { redirect_to speakers_url }
      format.json { head :no_content }
    end
  end

  private
    def set_speaker
      @speaker = Speaker.find(params[:id])
    end

    def speaker_params
      params.require(:speaker).permit(:parent_id, :language_id, :name, :hidden_markov_model, :language_model, :dictionary)
    end
end
