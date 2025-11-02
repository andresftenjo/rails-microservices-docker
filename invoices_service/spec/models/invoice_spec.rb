require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it "is invalid without amount" do
    invoice = Invoice.new(customer_id: 1, issued_on: Date.today)
    expect(invoice).not_to be_valid
  end
end
