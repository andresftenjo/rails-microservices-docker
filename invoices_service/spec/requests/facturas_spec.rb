require "rails_helper"

RSpec.describe "Facturas API", type: :request do
  before do
    # Stub external Customers API calls
    allow(CustomersApi).to receive(:customer_exists?).and_return(true)
  end

  describe "POST /facturas" do
    it "creates a valid invoice" do
      post "/facturas", params: {
        customer_id: 1,
        amount: 100.50,
        issued_on: "2025-10-31",
        notes: "Service fee"
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("ok")
      expect(json["data"]["amount"]).to eq("100.5")
    end

    it "rejects invalid invoice" do
      allow(CustomersApi).to receive(:customer_exists?).and_return(false)
      post "/facturas", params: {
        customer_id: 999,
        amount: 0,
        issued_on: "2025-10-31"
      }

      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("error")
      expect(json["errors"]).to include("Invalid customer")
    end
  end

  describe "GET /facturas/:id" do
    it "returns invoice if found" do
      invoice = Invoice.create!(customer_id: 1, amount: 200, issued_on: Date.today, notes: "Testing")
      get "/facturas/#{invoice.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["id"]).to eq(invoice.id)
    end

    it "returns 404 if not found" do
      get "/facturas/9999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /facturas (list)" do
    it "lists invoices by date range" do
      Invoice.create!(customer_id: 1, amount: 300, issued_on: "2025-10-01", notes: "Range test")
      get "/facturas?fechaInicio=2025-10-01&fechaFin=2025-10-31"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]).to be_an(Array)
    end
  end
end
