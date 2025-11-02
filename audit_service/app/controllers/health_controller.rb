# frozen_string_literal: true
class HealthController < ApplicationController
  include ResponseRenderer

  def index
    service_name = Rails.application.class.module_parent_name

    ActiveRecord::Base.connection.execute("SELECT 1")

    render_success({ service: service_name, database: "connected", ok: true })
  rescue => e
    Rails.logger.error("[HealthController] #{e.class}: #{e.message}")
    render_error("Health check failed: #{e.message}", status: :internal_server_error)
  end
end
