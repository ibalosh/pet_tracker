require 'rails_helper'

RSpec.describe Tracker, type: :model do
  describe "validations" do
    it "is valid when lost_tracker is true for a cat" do
      cat = Species.create!(name: "Cat")
      tracker_type = TrackerType.create!(category: "small", species: cat)
      owner = Owner.create!(name: "Alice", email: "alice@example.com")
      pet = Pet.create!(name: "Mittens", species: cat, owner: owner)

      tracker = Tracker.new(pet: pet, tracker_type: tracker_type, in_zone: true, lost_tracker: true)
      expect(tracker).to be_valid
    end

    it "is invalid when lost_tracker is true for a non-cat species" do
      dog = Species.create!(name: "Dog")
      tracker_type = TrackerType.create!(category: "large", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)

      tracker = Tracker.new(pet: pet, tracker_type: tracker_type, in_zone: true, lost_tracker: true)
      expect(tracker).not_to be_valid
      expect(tracker.errors[:lost_tracker]).to include("can only be true for cats")
    end
  end
end
