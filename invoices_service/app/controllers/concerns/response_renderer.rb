# frozen_string_literal: true
module ResponseRenderer
  extend ActiveSupport::Concern

  included do
    # For standard API responses
    def render_success(data = {}, status: :ok)
      render json: {
        data: data,
        status: "ok",
        errors: []
      }, status: status
    end

    def render_error(errors = [], status: :unprocessable_content)
      render json: {
        data: {},
        status: "error",
        errors: Array(errors)
      }, status: status
    end

    def render_not_found(message = "Resource not found")
      render_error([message], status: :not_found)
    end

    def render_internal_error(message = "Internal Server Error")
      render_error([message], status: :internal_server_error)
    end
  end
end
