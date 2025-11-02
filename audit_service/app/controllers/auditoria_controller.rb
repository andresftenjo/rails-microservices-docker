# frozen_string_literal: true
class AuditoriaController < ApplicationController
  include ResponseRenderer

  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable
  rescue_from StandardError, with: :handle_internal_error

  # POST /auditoria
  def create
    event = AuditEvent.create!(
      entity_type: params[:entity_type],
      entity_id: params[:entity_id],
      action: params[:action_name],
      status: params[:status],
      message: params[:message]
    )
    render_success(event, status: :created)
  end

  # GET /auditoria/:entity_id
  def show_by_entity
    events = AuditEvent.where(entity_id: params[:entity_id]).order(created_at: :desc)
    render_success(events)
  end

  private

  def handle_unprocessable(exception)
    Rails.logger.warn("[AuditService] Validation failed: #{exception.message}")
    render_error(exception.message, status: :unprocessable_content)
  end

  def handle_internal_error(exception)
    Rails.logger.error("[AuditService] Internal error: #{exception.class} - #{exception.message}")
    render_error("Internal Server Error", status: :internal_server_error)
  end
end
