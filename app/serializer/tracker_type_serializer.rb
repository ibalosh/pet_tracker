class TrackerTypeSerializer < BaseSerializer
  def initialize(tracker_type)
    @tracker_type = tracker_type
  end

  def as_json(*)
    {
      id: @tracker_type.id,
      category: @tracker_type.category,
      species: {
        id: @tracker_type.species_id,
        name: @tracker_type.species&.name
      }
    }
  end
end
