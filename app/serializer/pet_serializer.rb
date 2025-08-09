class PetSerializer < BaseSerializer
  def initialize(pet)
    @pet = pet
  end

  def as_json(*)
    {
      id:    @pet.id,
      name:  @pet.name,
      species: (@pet.association(:species).loaded? ? @pet.species.name : nil),
      owner:  (@pet.association(:owner).loaded?   ? { id: @pet.owner.id, name: @pet.owner.name } : nil),
      in_zone:       @pet.try(:in_zone),
      lost_tracker:  @pet.try(:lost_tracker)
    }.compact
  end
end
