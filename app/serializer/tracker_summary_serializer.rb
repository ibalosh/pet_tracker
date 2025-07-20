# app/serializers/tracker_summary_serializer.rb
class TrackerSummarySerializer
  def initialize(summaries:, species_map:, tracker_type_map:)
    @summaries = summaries
    @species_map = species_map
    @tracker_type_map = tracker_type_map
  end

  def as_json
    @summaries.map do |s|
      {
        pet_type: {
          id: s.species_id,
          name: @species_map[s.species_id]&.name || "Unknown"
        },
        tracker_type: {
          id: s.tracker_type_id,
          category: @tracker_type_map[s.tracker_type_id]&.category || "Unknown"
        },
        in_zone: s.in_zone,
        count: s.count
      }
    end
  end
end