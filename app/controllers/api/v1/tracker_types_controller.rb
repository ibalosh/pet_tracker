module Api
  module V1
    class TrackerTypesController < ApplicationController
      before_action :find_tracker_type, only: [ :show, :update, :destroy ]

      def index
        page_obj, data = pagy(TrackerType.all.includes(:species))
        render json: paged_response("tracker_types", TrackerTypeSerializer.collection(data), page_obj)
      end

      def show
        render json: TrackerTypeSerializer.new(@tracker_type).as_json
      end

      def create
        tracker_type = TrackerType.create!(tracker_type_params)
        render json: TrackerTypeSerializer.new(tracker_type).as_json, status: :created
      end

      def update
        @tracker_type.update!(tracker_type_params)
        render json: TrackerTypeSerializer.new(@tracker_type).as_json, status: :ok
      end

      def destroy
        @tracker_type.destroy
        head :no_content
      end

      private

      def find_tracker_type
        @tracker_type = TrackerType.find(params[:id])
      end

      def tracker_type_params
        params.permit(:category, :species_id)
      end
    end
  end
end
