require 'rails_helper'

RSpec.describe "Species", type: :request do
  describe "GET /api/v1/species" do
    it "returns http success" do
      get "/api/v1/species"
      expect(response).to have_http_status(:success)
    end

    it "returns paginated list of species" do
      create_list(:species, 5)

      get "/api/v1/species"
      json = JSON.parse(response.body)

      species = json["species"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(species.size).to eq(5)
      expect(pagination["total_items"]).to eq(5)
      expect(pagination["page"]).to eq(1)
      expect(pagination["total_pages"]).to eq(1)
    end

    it "respects pagination parameters" do
      create_list(:species, 10)

      get "/api/v1/species", params: { page: 2 }
      json = JSON.parse(response.body)

      species = json["species"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(species.size).to eq(5)
      expect(pagination["page"]).to eq(2)
      expect(pagination["total_pages"]).to eq(2)
      expect(pagination["total_items"]).to eq(10)
    end
  end

  describe "GET /api/v1/species/:id" do
    it "returns single species" do
      species = create(:species)

      get "/api/v1/species/#{species.id}"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(species.id)
      expect(json["name"]).to eq(species.name)
    end

    it "returns not found for non-existent species" do
      get "/api/v1/species/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end

  describe "POST /api/v1/species" do
    it "creates a new species" do
      post "/api/v1/species", params: { name: "Cat" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json["name"]).to eq("Cat")
    end

    it "increases species count" do
      expect { post "/api/v1/species", params: { name: "Dog" } }.to change(Species, :count).by(1)
    end

    it "returns error when name is missing" do
      post "/api/v1/species", params: {}
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name can't be blank.")
    end

    it "returns error when name is not unique" do
      create(:species, name: "Dog")

      post "/api/v1/species", params: { name: "Dog" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name has already been taken.")
    end

    it "returns error when name is too long" do
      long_name = "a" * 51
      post "/api/v1/species", params: { name: long_name }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"].to_s).to include("Name is too long")
    end

    it "returns error when trying to add two species with the same name" do
      post "/api/v1/species", params: { name: "Lion" }
      expect(response).to have_http_status(:created)

      post "/api/v1/species", params: { name: "Lion" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name has already been taken.")
    end
  end

  describe "PATCH /api/v1/species/:id" do
    it "updates an existing species" do
      species = create(:species, name: "Old")

      patch "/api/v1/species/#{species.id}", params: { name: "New" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["name"]).to eq("New")
    end

    it "returns error when updating with blank name" do
      species = create(:species)

      patch "/api/v1/species/#{species.id}", params: { name: "" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name can't be blank.")
    end

    it "returns not found for non-existent species" do
      patch "/api/v1/species/999", params: { name: "Ghost" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end

  describe "DELETE /api/v1/species/:id" do
    it "deletes an existing species" do
      species = create(:species)

      expect {
        delete "/api/v1/species/#{species.id}"
      }.to change(Species, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns not found for non-existent species" do
      delete "/api/v1/species/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end
end
