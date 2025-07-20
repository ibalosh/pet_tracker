# app/serializers/tracker_serializer.rb
class TrackerSerializer
  def initialize(tracker)
    @tracker = tracker
  end

  def as_json(*)
    {
      id: @tracker.id,
      in_zone: @tracker.in_zone,
      lost_tracker: @tracker.lost_tracker,
      pet: {
        id: @tracker.pet.id,
        name: @tracker.pet.name,
        species: {
          id: @tracker.pet.species.id,
          name: @tracker.pet.species.name
        }
      },
      tracker_type: {
        id: @tracker.tracker_type.id,
        category: @tracker.tracker_type.category
      }
    }
  end
end
