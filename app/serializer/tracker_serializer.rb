class TrackerSerializer < BaseSerializer
  def initialize(tracker)
    @tracker = tracker
  end

  def as_json
    {
      id: @tracker.id,
      in_zone: @tracker.in_zone,
      lost_tracker: @tracker.lost_tracker,
      pet: {
        id: @tracker.pet_id,
        name: @tracker.pet_name,
        species: {
          id: @tracker.pet.species_id,
          name: @tracker.pet.species_name
        }
      },
      tracker_type: {
        id: @tracker.tracker_type_id,
        category: @tracker.tracker_type_category
      }
    }
  end
end
