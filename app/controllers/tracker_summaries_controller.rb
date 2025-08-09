class TrackerSummariesController < ApplicationController
  def index
    summaries = Tracker.zone_summary(filters)

    species_map = Species.where(id: summaries.map(&:species_id)).index_by(&:id)
    tracker_type_map = TrackerType.where(id: summaries.map(&:tracker_type_id)).index_by(&:id)

    render json: {
      tracker_summaries: TrackerSummarySerializer.new(
        summaries: summaries,
        species_map: species_map,
        tracker_type_map: tracker_type_map
      ).as_json,
      total_items: summaries.sum(&:count)
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
