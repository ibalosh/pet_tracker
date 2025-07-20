require 'rails_helper'

RSpec.describe "TrackerTypes", type: :request do
  describe "GET /tracker_types" do
    it "returns http success" do
      get "/tracker_types"
      expect(response).to have_http_status(:success)
    end

    it "returns paginated list of tracker types" do
      species = create(:species)
      create_list(:tracker_type, 5, species: species)

      get "/tracker_types"
      json = JSON.parse(response.body)

      tracker_types = json["tracker_types"]
      pagination = json["pagination"]

      expect(response).to have_http_status(:ok)
      expect(tracker_types.size).to eq(5)
      expect(pagination["total_count"]).to eq(5)
    end

    it "respects pagination parameters" do
      species = create(:species)
      create_list(:tracker_type, 10, species: species)

      get "/tracker_types", params: { page: 2, items: 5 }
      json = JSON.parse(response.body)

      tracker_types = json["tracker_types"]
      pagination = json["pagination"]

      expect(response).to have_http_status(:ok)
      expect(tracker_types.size).to eq(5)
      expect(pagination["current_page"]).to eq(2)
    end
  end

  describe "GET /tracker_types/:id" do
    it "returns a single tracker type" do
      tracker_type = create(:tracker_type)

      get "/tracker_types/#{tracker_type.id}"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(tracker_type.id)
      expect(json["category"]).to eq(tracker_type.category)
    end

    it "returns not found for invalid id" do
      get "/tracker_types/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end

  describe "POST /tracker_types" do
    it "creates a new tracker type" do
      species = create(:species)
      post "/tracker_types", params: { category: "small", species_id: species.id }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(json["category"]).to eq("small")
    end

    it "returns error when category is missing" do
      species = create(:species)
      post "/tracker_types", params: { tracker_type: { species_id: species.id } }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Category can't be blank")
    end

    it "returns error when species_id is missing" do
      post "/tracker_types", params: { tracker_type: { category: "RFID" } }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Species must exist")
    end

    it "rejects duplicate category for the same species" do
      species = create(:species)
      create(:tracker_type, category: "small", species: species)

      post "/tracker_types", params: { category: "small", species_id: species.id }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Category has already been taken")
    end

    it "allows same category for different species" do
      cat_species = create(:species, name: "Cat")
      dog_species = create(:species, name: "Dog")
      create(:tracker_type, category: "large", species: cat_species)

      post "/tracker_types", params: { category: "large", species_id: dog_species.id }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(json["category"]).to eq("large")
    end
  end

  describe "PATCH /tracker_types/:id" do
    it "updates an existing tracker type" do
      tracker_type = create(:tracker_type)
      patch "/tracker_types/#{tracker_type.id}", params: { category: "Updated" }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["category"]).to eq("Updated")
    end

    it "rejects updating to duplicate category in same species" do
      species = create(:species)
      create(:tracker_type, category: "small", species: species)
      tracker_type = create(:tracker_type, category: "large", species: species)

      patch "/tracker_types/#{tracker_type.id}", params: { category: "small" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Category has already been taken")
    end

    it "returns validation error for blank category" do
      tracker_type = create(:tracker_type)
      patch "/tracker_types/#{tracker_type.id}", params: { category: "" }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Category can't be blank")
    end

    it "returns not found for non-existent tracker type" do
      patch "/tracker_types/999", params: { tracker_type: { category: "Ghost" } }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end

  describe "DELETE /tracker_types/:id" do
    it "deletes a tracker type" do
      tracker_type = create(:tracker_type)
      expect {
        delete "/tracker_types/#{tracker_type.id}"
      }.to change(TrackerType, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns not found for invalid id" do
      delete "/tracker_types/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end
end
