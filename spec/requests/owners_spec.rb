require 'rails_helper'

RSpec.describe "Owners", type: :request do
  describe "GET /owners" do
    it "returns http success" do
      get "/owners"
      expect(response).to have_http_status(:success)
    end

    it "returns paginated list of owners" do
      create_list(:owner, 5)

      get "/owners"
      json = JSON.parse(response.body)

      owners = json["owners"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(owners.size).to eq(5)
      expect(pagination["total_items"]).to eq(5)
      expect(pagination["items_in_page"]).to eq(5)
      expect(pagination["total_pages"]).to eq(1)
    end

    it "respects pagination parameters" do
      create_list(:owner, 10)

      get "/owners", params: { page: 2, items: 5 }
      json = JSON.parse(response.body)

      owners = json["owners"]
      pagination = json["meta"]

      expect(response).to have_http_status(:ok)
      expect(owners.size).to eq(5)
      expect(pagination["page"]).to eq(2)
      expect(pagination["total_pages"]).to eq(2)
      expect(pagination["total_items"]).to eq(10)
    end
  end

  describe "GET /owners/:id" do
    it "returns single owner" do
      owner = create(:owner)

      get "/owners/#{owner.id}"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(owner.id)
      expect(json["name"]).to eq(owner.name)
    end

    it "returns not found for non-existent owner" do
      get "/owners/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end

  describe "POST /owners" do
    it "creates a new owner" do
      post "/owners", params: { name: "Alice", email: "alice@example.com" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json["name"]).to eq("Alice")
      expect(json["email"]).to eq("alice@example.com")
    end

    it "creates a new owner" do
      expect { post "/owners", params: { name: "Alice", email: "alice@example.com" } }.
        to change(Owner, :count).by(1)

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(json["name"]).to eq("Alice")
      expect(json["email"]).to eq("alice@example.com")
    end

    it "returns error when name is missing" do
      post "/owners", params: { email: "alice@example.com" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Name can't be blank.")
    end

    it "returns error when email is missing" do
      post "/owners", params: { name: "Alice" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Email can't be blank.")
    end

    it "returns error for invalid email format" do
      post "/owners", params: { name: "Alice", email: "invalid_email" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Email is invalid.")
    end

    it "returns error for duplicate email" do
      create(:owner, email: "alice@example.com")

      post "/owners", params: { name: "Another", email: "alice@example.com" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Email has already been taken.")
    end
  end

  describe "PATCH /owners/:id" do
    it "updates an existing owner" do
      owner = create(:owner, name: "Old Name")

      patch "/owners/#{owner.id}", params: { name: "New Name" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["name"]).to eq("New Name")
    end

    it "returns validation error on invalid update" do
      owner = create(:owner)

      patch "/owners/#{owner.id}", params: { email: "bad" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to include("Email is invalid.")
    end

    it "returns not found for non-existent owner" do
      patch "/owners/999", params: { name: "Ghost" }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end

  describe "DELETE /owners/:id" do
    it "deletes an existing owner" do
      owner = create(:owner)

      expect {
        delete "/owners/#{owner.id}"
      }.to change(Owner, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns not found when deleting non-existent owner" do
      delete "/owners/999"
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json["errors"].to_s).to include("Couldn't find")
    end
  end
end
