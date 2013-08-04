class SegmentsController < ApplicationController
  before_action :set_segment, only: [:show, :edit, :update, :destroy]

  has_sticky_params :recording_id

  def index
    @segments = finder.paginate page: params[:page]
  end

  def export
    @segments = finder.all
    render 'index'
  end

  def show
  end

  def new
    @segment = Segment.new
  end

  def edit
  end

  def create
    @segment = Segment.new(segment_params)

    respond_to do |format|
      if @segment.save
        format.html { redirect_to @segment, notice: 'Segment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @segment }
      else
        format.html { render action: 'new' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to @segment, notice: 'Segment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to segments_url }
      format.json { head :no_content }
    end
  end

  private
    def finder
      @chain    = Segment.chain
      @chain.where(recording_id: params[:recording_id]) if params[:recording_id]
      @chain.finder
    end

    def set_segment
      @segment = Segment.find(params[:id])
    end

    def segment_params
      params.require(:segment).permit(:recording_id, :start_time, :end_time)
    end
end
