class CustomersApi
  def self.customer_exists?(customer_id)
    base = ENV.fetch("CUSTOMERS_BASE_URL", "http://localhost:3001")
    res = Faraday.get("#{base}/clientes/#{customer_id}")
    res.status == 200
  rescue
    false
  end
end