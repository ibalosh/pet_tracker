class Tracker < ApplicationRecord
  belongs_to :pet
  belongs_to :tracker_type

  validate :lost_tracker_only_for_cats

  def lost_tracker_only_for_cats
    if lost_tracker && pet.species.name.downcase != "cat"
      errors.add(:lost_tracker, "can only be true for cats")
    end
  end

  def self.zone_summary(filters = {})
    query = joins(:pet, :tracker_type)

    # default to in_zone false, if parameter is not provided
    zone_value = filters[:in_zone].nil? ? false : filters[:in_zone]

    # we always assume tracker is not lost, otherwise we can't detect if tracker is in zone
    query = query.where(lost_tracker: false, in_zone: zone_value)

    # filtering by pet type and tracker type
    query = query.joins(pet: :species).where(species: { name: filters[:pet_type] }) if filters[:pet_type]
    query = query.joins(:tracker_type).where(tracker_types: { category: filters[:tracker_type] }) if filters[:tracker_type]

    query
      .group("pets.species_id", "tracker_types.id")
      .select(:in_zone,
        :lost_tracker,
        'pets.species_id AS species_id,
        tracker_types.id AS tracker_type_id,
        COUNT(*) AS count'
      )
  end
end
