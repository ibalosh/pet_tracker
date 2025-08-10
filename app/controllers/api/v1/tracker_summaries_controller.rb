module Api
  module V1
    class TrackerSummariesController < ApplicationController
      def index
        summaries = Tracker.zone_summary_with_names(filters)

        render json: {
          tracker_summaries: summaries.map { |s|
            {
              pet_type: s.species_name,
              tracker_type: s.tracker_type_name,
              in_zone: filters.fetch(:in_zone, false),
              count: s.count
            }
          },
          total_items: summaries.sum { |s| s[:count] }
        }
      end

      private

      def filters
        {
          in_zone: in_zone_filter,
          pet_type: params[:pet_type].presence,
          tracker_type: params[:tracker_type].presence
        }.compact
      end

      def in_zone_filter
        return nil if params[:in_zone].nil?

        ActiveModel::Type::Boolean.new.cast(params[:in_zone])
      end
    end
  end
end
