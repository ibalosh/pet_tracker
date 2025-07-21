class Pet < ApplicationRecord
  belongs_to :species
  belongs_to :owner
  has_many :trackers, dependent: :destroy
  has_many :tracker_types, through: :trackers

  delegate :id, :name, to: :species, prefix: true

  validates :name, presence: true
end
