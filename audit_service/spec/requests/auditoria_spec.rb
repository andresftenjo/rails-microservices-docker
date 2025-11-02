require "rails_helper"

RSpec.describe "Auditoria API", type: :request do
  describe "POST /auditoria" do
    it "creates an audit event" do
      post "/auditoria", params: {
        entity_type: "factura",
        entity_id: 1,
        action_name: "create",
        status: "ok",
        message: "Factura creada correctamente"
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["data"]["entity_type"]).to eq("factura")
      expect(json["status"]).to eq("ok")
    end

  end

  describe "GET /auditoria/:entity_id" do
    it "returns events for entity" do
      AuditEvent.create!(entity_type: "factura", entity_id: 2, action: "read", status: "ok")
      get "/auditoria/2"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]).to be_an(Array)
    end
  end
end
