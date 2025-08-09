class OwnerSerializer < BaseSerializer
  def initialize(owner) = (@o = owner)
  def as_json(*) = { id: @o.id, name: @o.name, email: @o.email }
end
