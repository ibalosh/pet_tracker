class Tracker < ApplicationRecord
  belongs_to :pet
  belongs_to :tracker_type

  delegate :name, :id, to: :pet, prefix: true
  delegate :category, :id, to: :tracker_type, prefix: true

  validate :lost_tracker_only_for_cats

  def lost_tracker_only_for_cats
    if lost_tracker && pet.species.name.downcase != "cat"
      errors.add(:lost_tracker, "can only be true for cats")
    end
  end

  def self.zone_summary(filters = {})
    query = joins(:pet, :tracker_type)

    zone_value = filters[:in_zone].nil? ? false : filters[:in_zone]
    query = query.where(lost_tracker: false, in_zone: zone_value)
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
