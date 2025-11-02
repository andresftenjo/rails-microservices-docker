class FetchInvoiceUseCase
  def call(id)
    invoice = Invoice.find_by(id: id)
    if invoice
      AuditClient.log(entity_type: "factura", entity_id: id, action_name: "read", status: "ok")
      [:ok, invoice]
    else
      AuditClient.log(entity_type: "factura", entity_id: id, action_name: "read", status: "error", message: "Not Found")
      [:not_found, nil]
    end
  end
end
