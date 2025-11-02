# frozen_string_literal: true
class FacturasController < ApplicationController
  include ResponseRenderer

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable
  rescue_from StandardError, with: :handle_internal_error

  # POST /facturas
  def create
    result, data = CreateInvoiceUseCase.new.call(invoice_params.to_h.symbolize_keys)

    case result
    when :ok
      AuditClient.log(entity_type: "factura", entity_id: data.id, action_name: "create", status: "ok")
      render_success(data, status: :created)
    when :error
      AuditClient.log(
        entity_type: "factura",
        entity_id: nil,
        action_name: "create",
        status: "error",
        message: Array(data).join(", ")
      )
      render_error(data, status: :unprocessable_content)
    else
      AuditClient.log(
        entity_type: "factura",
        entity_id: nil,
        action_name: "create",
        status: "error",
        message: "Unexpected result from use case"
      )
      render_error("Unexpected error", status: :internal_server_error)
    end
  end

  # GET /facturas/:id
  def show
    result, data = FetchInvoiceUseCase.new.call(params[:id])
    if result == :ok
      AuditClient.log(entity_type: "factura", entity_id: params[:id], action_name: "read", status: "ok")
      render_success(data)
    else
      AuditClient.log(entity_type: "factura", entity_id: params[:id], action_name: "read", status: "error", message: "Not found")
      render_error("Invoice not found", status: :not_found)
    end
  end

  # GET /facturas?fechaInicio&fechaFin
  def index
    if params[:fechaInicio].present? && params[:fechaFin].present?
        start_date = Date.parse(params[:fechaInicio]) rescue nil
        end_date   = Date.parse(params[:fechaFin]) rescue nil
        invoices = Invoice.where(issued_on: start_date..end_date)
    else
        invoices = Invoice.all.order(created_at: :desc)
    end

    render_success(invoices)
    rescue => e
    Rails.logger.error("[InvoicesService] Error in index: #{e.class} - #{e.message}")
    render_error("Failed to fetch invoices", status: :internal_server_error)
  end


  private

  def invoice_params
    params.permit(:customer_id, :amount, :issued_on, :notes)
  end

  def handle_not_found(exception)
    AuditClient.log(entity_type: "factura", entity_id: params[:id], action_name: "read", status: "error", message: exception.message)
    render_error("Invoice not found", status: :not_found)
  end

  def handle_unprocessable(exception)
    render_error(exception.message, status: :unprocessable_content)
  end

  def handle_internal_error(exception)
    Rails.logger.error("[InvoicesService] #{exception.message}")
    render_error("Internal Server Error", status: :internal_server_error)
  end
end
