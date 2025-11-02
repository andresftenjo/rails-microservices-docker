class SearchInvoicesUseCase
  def call(from:, to:)
    invoices = Invoice.where("issued_on BETWEEN ? AND ?", from, to)
    AuditClient.log(entity_type: "factura", entity_id: nil, action_name: "read", status: "ok", message: "search")
    [:ok, invoices]
  end
end
