require "rails_helper"

RSpec.describe "Clientes API", type: :request do
  describe "POST /clientes" do
    it "creates a valid customer" do
      post "/clientes", params: {
        name: "Acme Corp",
        tax_id: "900123456-7",
        email: "info@acme.com",
        address: "123 Main St"
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("ok")
      expect(json["data"]["name"]).to eq("Acme Corp")
    end

    it "returns 422 for invalid customer" do
      post "/clientes", params: { name: "" }
      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("error")
      expect(json["errors"]).not_to be_empty
    end
  end

  describe "GET /clientes/:id" do
    it "returns a customer if found" do
      customer = Customer.create!(name: "Beta", tax_id: "123", email: "beta@test.com", address: "X Street")
      get "/clientes/#{customer.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["id"]).to eq(customer.id)
      expect(json["status"]).to eq("ok")
    end

  end

  describe "GET /clientes" do
    it "lists all customers" do
      Customer.create!(name: "Acme", tax_id: "123", email: "a@b.com", address: "Main")
      get "/clientes"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]).to be_an(Array)
      expect(json["status"]).to eq("ok")
    end
  end
end
