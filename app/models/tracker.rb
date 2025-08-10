class Tracker < ApplicationRecord
  belongs_to :pet
  belongs_to :tracker_type

  delegate :name, to: :pet, prefix: true
  delegate :category, to: :tracker_type, prefix: true

  validate :lost_tracker_only_for_cats

  def lost_tracker_only_for_cats
    if lost_tracker && pet.species.name.downcase != "cat"
      errors.add(:lost_tracker, "can only be true for cats")
    end
  end

  def self.zone_summary_with_names(filters = {})
    base = joins(:tracker_type).joins(pet: :species)

    # default to in_zone false, if parameter is not provided
    zone_value = filters[:in_zone].nil? ? false : filters[:in_zone]

    # we always assume tracker is not lost, otherwise we can't detect if tracker is in zone
    # and then filter by pet type and tracker type
    base = base.where(lost_tracker: false, in_zone: zone_value)
    base = base.where(species: { name: filters[:pet_type] })            if filters[:pet_type]
    base = base.where(tracker_types: { category: filters[:tracker_type] }) if filters[:tracker_type]

    # Group by both the foreign keys (IDs) and their human-readable names.
    #
    # Why: SQL requires every selected non-aggregated column to be in GROUP BY.
    # SQLite is permissive and may *appear* to work without grouping by names,
    # returning an arbitrary value. Postgres/MySQL (especially with
    # ONLY_FULL_GROUP_BY) will reject that. Grouping by names here makes the
    # query portable and deterministic across databases.
    #
    # This does not change the semantics: in a normalized schema `species.name`
    # and `tracker_types.category` are functionally dependent on their IDs.
    # (If you want to keep GROUP BY on IDs only, the portable alternative is
    # to aggregate the labels, e.g. MIN(species.name) AS species_name.)
    base
      .group("pets.species_id", "species.name", "tracker_types.id", "tracker_types.category")
      .select(
        "pets.species_id AS species_id",
        "species.name AS species_name",
        "tracker_types.id AS tracker_type_id",
        "tracker_types.category AS tracker_type_name",
        "COUNT(*) AS count"
      )
  end
end
