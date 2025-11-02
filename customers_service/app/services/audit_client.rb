# frozen_string_literal: true
class AuditClient
  def self.log(entity_type:, entity_id:, action_name:, status:, message: nil)
    base = ENV.fetch("AUDIT_BASE_URL", "http://localhost:3003")
    Faraday.post("#{base}/auditoria", {
      entity_type: entity_type,
      entity_id: entity_id,
      action_name: action_name,
      status: status,
      message: message
    })
  rescue => e
    Rails.logger.error("[AuditClient] Failed to log event: #{e.message}")
  end
end
