class TrackersController < ApplicationController
  before_action :find_tracker, only: [ :show, :update, :destroy ]
  def index
    trackers = Tracker.includes(:tracker_type, pet: :species)
    render json: trackers.map { |t| TrackerSerializer.new(t).as_json }
  end

  # app/controllers/trackers_controller.rb
  def show
    render json: TrackerSerializer.new(@tracker).as_json
  end

  def create
    tracker = Tracker.create!(tracker_params)
    render json: tracker, status: :created
  end

  def update
    @tracker.update!(tracker_params)
    render json: @tracker, status: :ok
  end

  def destroy
    @tracker.destroy
    head :no_content
  end

  private

  def find_tracker
    @tracker = Tracker.find(tracker_param_id)
  end

  def tracker_param_id
    params[:id]
  end

  def tracker_params
    params.permit(:pet_id, :tracker_type_id, :in_zone, :lost_tracker)
  end
end
