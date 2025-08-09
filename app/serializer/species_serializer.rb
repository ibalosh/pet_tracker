class SpeciesSerializer < BaseSerializer
  def initialize(species) = (@species = species)
  def as_json(*) = { id: @species.id, name: @species.name }
end
