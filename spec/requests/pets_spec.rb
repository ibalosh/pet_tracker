require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let!(:owner) { create(:owner) }
  let!(:species) { create(:species) }

  describe "GET /pets" do
    it "returns paginated list of pets" do
      create_list(:pet, 5, owner: owner, species: species)

      get "/pets"
      json = JSON.parse(response.body)

      pets = json["data"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(pets.size).to eq(5)
      expect(pagination["total_items"]).to eq(5)
    end

    it "respects pagination parameters" do
      create_list(:pet, 10, owner: owner, species: species)

      get "/pets", params: { page: 2, items: 5 }
      json = JSON.parse(response.body)

      pets = json["data"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(pets.size).to eq(5)
      expect(pagination["page"]).to eq(2)
    end
  end

  describe "GET /pets/:id" do
    it "returns a pet" do
      pet = create(:pet, owner: owner, species: species)

      get "/pets/#{pet.id}"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(pet.id)
      expect(json["name"]).to eq(pet.name)
    end

    it "returns 404 for non-existent pet" do
      get "/pets/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end

  describe "POST /pets" do
    it "creates a new pet" do
      post "/owners/#{owner.id}/pets", params: {
        name: "Whiskers",
        species_id: species.id
      }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json["name"]).to eq("Whiskers")
    end

    it "fails with missing name" do
      post "/owners/#{owner.id}/pets", params: {
        species_id: species.id
      }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name can't be blank")
    end

    it "fails with invalid owner_id" do
      post "/owners/999/pets", params: {
        name: "BadPet",
        species_id: species.id
      }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Owner must exist")
    end
  end

  describe "PATCH /pets/:id" do
    it "updates a pet" do
      pet = create(:pet, name: "Old", owner: owner, species: species)

      patch "/owners/#{owner.id}/pets/#{pet.id}", params: { name: "New" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["name"]).to eq("New")
    end

    it "returns validation error on blank name" do
      pet = create(:pet, owner: owner, species: species)

      patch "/owners/#{owner.id}/pets/#{pet.id}", params: { name: "" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name can't be blank")
    end

    it "returns 404 for non-existent pet" do
      patch "/owners/#{owner.id}/pets/999", params: { name: "Ghost" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end

  describe "DELETE /pets/:id" do
    it "deletes a pet" do
      pet = create(:pet, owner: owner, species: species)

      expect {
        delete "/pets/#{pet.id}"
      }.to change(Pet, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 when deleting non-existent pet" do
      delete "/pets/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to include("Couldn't find")
    end
  end
end
