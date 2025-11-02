# frozen_string_literal: true
class CreateInvoiceUseCase
  def call(params)
    customer_exists = CustomersApi.customer_exists?(params[:customer_id])
    unless customer_exists
      AuditClient.log(entity_type: "factura", entity_id: nil, action_name: "create", status: "error", message: "Invalid customer")
      return [:error, ["Invalid customer"]]
    end

    invoice = Invoice.new(params)
    if invoice.save
      AuditClient.log(entity_type: "factura", entity_id: invoice.id, action_name: "create", status: "ok")
      [:ok, invoice]
    else
      AuditClient.log(entity_type: "factura", entity_id: nil, action_name: "create", status: "error", message: invoice.errors.full_messages.join(", "))
      [:error, invoice.errors.full_messages]
    end
  end
end
