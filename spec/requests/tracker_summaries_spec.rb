require 'rails_helper'

RSpec.describe "TrackerSummaries", type: :request do
  describe "GET /tracker_summaries" do
    it "returns empty list when no data exists" do
      get "/tracker_summaries"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["tracker_summaries"]).to eq([])
      expect(json["total_count"]).to eq(0)
    end

    it "returns single summary for multiple pets with same tracker_type and species" do
      dog = Species.create!(name: "Dog")
      type = TrackerType.create!(category: "large", species: dog)

      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet1 = Pet.create!(name: "Rex", species: dog, owner: owner)
      pet2 = Pet.create!(name: "Max", species: dog, owner: owner)

      Tracker.create!(pet: pet1, tracker_type: type, in_zone: false)
      Tracker.create!(pet: pet2, tracker_type: type, in_zone: false)

      get "/tracker_summaries", params: { in_zone: false }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"].size).to eq(1)
      expect(json["tracker_summaries"].first["count"]).to eq(2)
      expect(json["tracker_summaries"].first["tracker_type"]["category"]).to eq("large")
      expect(json["total_count"]).to eq(2)
    end

    # spec/requests/tracker_summaries_spec.rb
    it "aggregates correctly with mixed owners and pets" do
      dog = Species.create!(name: "Dog")
      type = TrackerType.create!(category: "medium", species: dog)

      owner1 = Owner.create!(name: "John", email: "a@example.com")
      owner2 = Owner.create!(name: "Milan", email: "b@example.com")

      pet1 = Pet.create!(name: "Dog1", species: dog, owner: owner1)
      pet2 = Pet.create!(name: "Dog2", species: dog, owner: owner2)

      Tracker.create!(pet: pet1, tracker_type: type, in_zone: false)
      Tracker.create!(pet: pet2, tracker_type: type, in_zone: false)

      get "/tracker_summaries", params: { in_zone: false }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"].size).to eq(1)
      expect(json["tracker_summaries"].first["count"]).to eq(2)
    end

    it "returns summary without filters where default in_zone will be used" do
      dog = Species.create!(name: "Dog")
      tracker_type = TrackerType.create!(category: "medium", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)
      Tracker.create!(pet: pet, tracker_type: tracker_type, in_zone: false)

      get "/tracker_summaries"
      json = JSON.parse(response.body)

      tracker_data = json["tracker_summaries"].first
      expect(tracker_data).not_to be_nil
      expect(tracker_data["pet_type"]["name"]).to eq("Dog")
      expect(tracker_data["tracker_type"]["category"]).to eq("medium")
      expect(tracker_data["count"]).to eq(1)
      expect(json["total_count"]).to eq(1)
    end

    it "returns empty result when filtered by in_zone = true and all are false" do
      dog = Species.create!(name: "Dog")
      type = TrackerType.create!(category: "medium", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)
      Tracker.create!(pet: pet, tracker_type: type, in_zone: false)

      get "/tracker_summaries", params: { in_zone: true }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"]).to eq([])
      expect(json["total_count"]).to eq(0)
    end

    it "filters by in_zone = false and returns matching results" do
      dog = Species.create!(name: "Dog")
      type = TrackerType.create!(category: "medium", species: dog)
      owner1 = Owner.create!(name: "Bob", email: "bob@example.com")
      owner2 = Owner.create!(name: "John", email: "john@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner1)
      pet2 = Pet.create!(name: "Wolf", species: dog, owner: owner2)

      Tracker.create!(pet: pet, tracker_type: type, in_zone: false)
      Tracker.create!(pet: pet2, tracker_type: type, in_zone: true)

      get "/tracker_summaries", params: { in_zone: false }
      json = JSON.parse(response.body)

      tracker_data = json["tracker_summaries"].first
      expect(tracker_data["pet_type"]["name"]).to eq("Dog")
      expect(tracker_data["tracker_type"]["category"]).to eq("medium")
      expect(tracker_data["count"]).to eq(1)
      expect(json["total_count"]).to eq(1)
    end

    it "filters by pet_type and returns correct results" do
      cat = Species.create!(name: "Cat")
      dog = Species.create!(name: "Dog")

      small_cat_tracker = TrackerType.create!(category: "small", species: cat)
      medium_dog_tracker = TrackerType.create!(category: "medium", species: dog)

      owner = Owner.create!(name: "Alice", email: "alice@example.com")
      cat_pet = Pet.create!(name: "Mittens", species: cat, owner: owner)
      dog_pet = Pet.create!(name: "Rex", species: dog, owner: owner)

      Tracker.create!(pet: cat_pet, tracker_type: small_cat_tracker, in_zone: false)
      Tracker.create!(pet: dog_pet, tracker_type: medium_dog_tracker, in_zone: false)

      get "/tracker_summaries", params: { in_zone: false, pet_type: "Cat" }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"].size).to eq(1)
      summary = json["tracker_summaries"].first
      expect(summary["pet_type"]["name"]).to eq("Cat")
      expect(summary["tracker_type"]["category"]).to eq("small")
      expect(summary["count"]).to eq(1)
      expect(json["total_count"]).to eq(1)
    end

    it "returns empty result for unknown pet_type" do
      dog = Species.create!(name: "Dog")
      tracker_type = TrackerType.create!(category: "medium", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)
      Tracker.create!(pet: pet, tracker_type: tracker_type, in_zone: false)

      get "/tracker_summaries", params: { pet_type: "Dragon" }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"].size).to eq(0)
      expect(json["total_count"]).to eq(0)
    end

    it "filters by tracker_type and returns correct summary" do
      dog = Species.create!(name: "Dog")
      tracker_type_medium = TrackerType.create!(category: "medium", species: dog)
      tracker_type_large = TrackerType.create!(category: "large", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet_rex = Pet.create!(name: "Rex", species: dog, owner: owner)
      pet_wolf = Pet.create!(name: "Wolf", species: dog, owner: owner)
      Tracker.create!(pet: pet_rex, tracker_type: tracker_type_medium, in_zone: false)
      Tracker.create!(pet: pet_wolf, tracker_type: tracker_type_large, in_zone: false)

      get "/tracker_summaries", params: { tracker_type: "medium" }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"].size).to eq(1)
      expect(json["total_count"]).to eq(1)
    end

    it "returns empty result for unknown tracker_type" do
      dog = Species.create!(name: "Dog")
      tracker_type = TrackerType.create!(category: "medium", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)
      Tracker.create!(pet: pet, tracker_type: tracker_type, in_zone: false)

      get "/tracker_summaries", params: { tracker_type: "giga" }
      json = JSON.parse(response.body)

      expect(json["tracker_summaries"]).to eq([])
      expect(json["total_count"]).to eq(0)
    end

    it "filters by pet_type and tracker_type together" do
      cat = Species.create!(name: "Cat")
      small_tracker = TrackerType.create!(category: "small", species: cat)
      medium_tracker = TrackerType.create!(category: "medium", species: cat)

      owner = Owner.create!(name: "Alice", email: "alice@example.com")
      pet1 = Pet.create!(name: "Luna", species: cat, owner: owner)
      pet2 = Pet.create!(name: "Milo", species: cat, owner: owner)

      Tracker.create!(pet: pet1, tracker_type: small_tracker, in_zone: false)
      Tracker.create!(pet: pet2, tracker_type: medium_tracker, in_zone: false)

      get "/tracker_summaries", params: {
        in_zone: false,
        pet_type: "Cat",
        tracker_type: "small"
      }

      json = JSON.parse(response.body)
      expect(json["tracker_summaries"].size).to eq(1)
      expect(json["tracker_summaries"].first["tracker_type"]["category"]).to eq("small")
      expect(json["total_count"]).to eq(1)
    end

    it "filters by in_zone, pet_type, and tracker_type together" do
      dog = Species.create!(name: "Dog")
      type = TrackerType.create!(category: "large", species: dog)
      owner = Owner.create!(name: "Bob", email: "bob@example.com")
      pet = Pet.create!(name: "Rex", species: dog, owner: owner)

      Tracker.create!(pet: pet, tracker_type: type, in_zone: false)

      get "/tracker_summaries", params: {
        in_zone: false,
        pet_type: "Dog",
        tracker_type: "large"
      }

      json = JSON.parse(response.body)
      expect(json["tracker_summaries"].size).to eq(1)
      expect(json["total_count"]).to eq(1)
    end
  end
end
