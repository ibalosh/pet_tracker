class TrackerType < ApplicationRecord
  belongs_to :species
  has_many :trackers, dependent: :destroy
  has_many :pets, through: :trackers

  validates :category, presence: true
  validates :category, uniqueness: { scope: :species_id }
end
