require 'rails_helper'

RSpec.describe "Trackers", type: :request do
  let(:species) { create(:species) }
  let(:owner) { create(:owner) }
  let(:pet) { create(:pet, owner: owner, species: species) }
  let(:tracker_type) { create(:tracker_type, species: species) }

  describe "GET /trackers" do
    it "returns http success" do
      get "/trackers"
      expect(response).to have_http_status(:success)
    end

    it "returns list of trackers with pet and tracker_type details" do
      create_list(:tracker, 3, pet: pet, tracker_type: tracker_type)

      get "/trackers"
      json = JSON.parse(response.body)
      trackers = json["trackers"]
      pagination = json["pagination"]

      expect(response).to have_http_status(:ok)
      expect(trackers.size).to eq(3)
      expect(trackers.first["pet"]["name"]).to eq(pet.name)
      expect(trackers.first["pet"]["species"]["name"]).to eq(pet.species.name)
      expect(trackers.first["tracker_type"]["category"]).to eq(tracker_type.category)
      expect(pagination["total_count"]).to eq(3)
      expect(pagination["current_page"]).to eq(1)
      expect(pagination["total_pages"]).to eq(1)
    end
  end

  describe "GET /trackers/:id" do
    it "returns a single tracker" do
      tracker = create(:tracker, pet: pet, tracker_type: tracker_type)

      get "/trackers/#{tracker.id}"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(tracker.id)
    end

    it "returns not found for invalid id" do
      get "/trackers/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end

  describe "POST /trackers" do
    it "creates a tracker" do
      post "/trackers", params: {
          pet_id: pet.id,
          tracker_type_id: tracker_type.id,
          in_zone: true,
          lost_tracker: false
      }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json["in_zone"]).to eq(true)
    end

    it "returns error if pet_id is missing" do
      post "/trackers", params: { tracker_type_id: tracker_type.id }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Pet must exist")
    end
  end

  describe "PATCH /trackers/:id" do
    it "updates a tracker" do
      tracker = create(:tracker, pet: pet, tracker_type: tracker_type, in_zone: true)

      get "/trackers/#{tracker.id}"
      json = JSON.parse(response.body)
      expect(json["in_zone"]).to eq(true)

      patch "/trackers/#{tracker.id}", params: { in_zone: false }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["in_zone"]).to eq(false)
    end

    it "returns error for invalid update" do
      tracker = create(:tracker, pet: pet, tracker_type: tracker_type)

      patch "/trackers/#{tracker.id}", params: { pet_id: nil }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Pet must exist")
    end

    it "returns not found for non-existent tracker" do
      patch "/trackers/999", params: { tracker: { in_zone: true } }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /trackers/:id" do
    it "deletes a tracker" do
      tracker = create(:tracker, pet: pet, tracker_type: tracker_type)

      expect { delete "/trackers/#{tracker.id}" }.to change(Tracker, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found when deleting non-existent tracker" do
      delete "/trackers/999"

      expect(response).to have_http_status(:not_found)
    end
  end
end
