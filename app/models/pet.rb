class Pet < ApplicationRecord
  belongs_to :species
  belongs_to :owner
  has_many :trackers, dependent: :destroy
  has_many :tracker_types, through: :trackers

  validates :name, presence: true
  # .as_json(include: { species: { only: [:id, :name] }, owner: { only: [:id, :name, :email] } }, except: [:created_at, :updated_at])
end
