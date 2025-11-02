# frozen_string_literal: true
class ClientesController < ApplicationController
  include ResponseRenderer

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid,  with: :handle_unprocessable
  rescue_from StandardError,                with: :handle_internal_error

  # POST /clientes
  def create
    customer = Customer.new(customer_params)

    if customer.save
      AuditClient.log(entity_type: "cliente", entity_id: customer.id, action_name: "create", status: "ok")
      render_success(customer, status: :created)
    else
      AuditClient.log(
        entity_type: "cliente",
        entity_id: nil,
        action_name: "create",
        status: "error",
        message: customer.errors.full_messages.join(", ")
      )
      render_error(customer.errors.full_messages, status: :unprocessable_content)
    end
  end

  # GET /clientes/:id
  def show
    customer = Customer.find(params[:id])
    AuditClient.log(entity_type: "cliente", entity_id: customer.id, action_name: "read", status: "ok")
    render_success(customer)
  end

  # GET /clientes
  def index
    customers = Customer.all
    AuditClient.log(entity_type: "cliente", entity_id: nil, action_name: "read", status: "ok", message: "index")
    render_success(customers)
  end

  private

  def customer_params
    params.permit(:name, :tax_id, :email, :address)
  end

  def handle_not_found(exception)
    Rails.logger.warn("[CustomersService] Not found: #{exception.message}")

    begin
      AuditClient.log(
        entity_type: "cliente",
        entity_id: params[:id],
        action_name: "read",
        status: "error",
        message: exception.message
      )
    rescue => log_error
      Rails.logger.warn("[CustomersService] Audit log failed in handle_not_found: #{log_error.message}")
    end

    render_error("Customer not found", status: :not_found)
  end

  def handle_unprocessable(exception)
    render_error(exception.message, status: :unprocessable_content)
  end

  def handle_internal_error(exception)
    Rails.logger.error("[CustomersService] #{exception.message}")
    render_error("Internal Server Error", status: :internal_server_error)
  end
end
