class ApplicationController < ActionController::API
    include ResponseRenderer

    def health
        render_success({ service: Rails.application.class.module_parent_name, ok: true })
    end

    rescue_from Exception do |e|
        Rails.logger.error("🚨 Unhandled exception: #{e.class} - #{e.message}")
        Rails.logger.error(e.backtrace.first(5).join("\n"))
        render json: { error: e.message, type: e.class.name }, status: :internal_server_error
    end
end
