class Species < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :tracker_types, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
