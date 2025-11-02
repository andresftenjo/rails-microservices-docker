RSpec.describe Customer, type: :model do
  it "is invalid without a name" do
    c = Customer.new(email: "a@b.com", tax_id: "123")
    expect(c).not_to be_valid
  end
end
