require "rails_helper"

RSpec.describe "Health Endpoint", type: :request do
  it "returns ok for /health" do
    get "/health"
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("ok")
    expect(json["data"]["ok"]).to be true
  end
end
