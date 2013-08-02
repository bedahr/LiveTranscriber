class RecordingsController < ApplicationController
  before_action :set_recording, except: [ :index, :my, :new, :create ]

  def index
    @recordings = Recording.all
  end

  def my
    @recordings = @current_user.recordings.all
    render :index
  end

  def segments
  end

  def new
    @recording = Recording.new(params[:recording] && recording_params)
  end

  def import_segments
    Recording::SegmentImporter.new(@recording).import_lines!( params[:lines].to_s.split(/\n/) )
    @recording.segments.each(&:create_words!)
    redirect_to @recording
  end

  def import_words
    Recording::WordImporter.new(@recording).import_lines!( params[:lines].to_s.split(/\n/) )
    @recording.segments.each(&:assign_words!)
    redirect_to @recording
  end

  def prepare
    @recording.create_downsampled_wav_file! unless @recording.downsampled_wav_file.file?
    @recording.create_optimized_audio_file! unless @recording.optimized_audio_file.file?

    redirect_to @recording
  end

  def show
  end

  def edit
  end

  def create
    @recording = @current_user.recordings.new(recording_params)

    respond_to do |format|
      if @recording.save
        format.html { redirect_to @recording, notice: 'Recording was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recording }
      else
        format.html { render action: 'new' }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recording.update(recording_params)
        format.html { redirect_to @recording, notice: 'Recording was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recording.destroy
    redirect_to recordings_url
  end

private

  def set_recording
    @recording = Recording.find(params[:id])
  end

  def recording_params
    params.require(:recording).permit(:user_id, :url, :original_audio_file)
  end

end
