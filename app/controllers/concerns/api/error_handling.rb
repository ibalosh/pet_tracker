module Api
  module ErrorHandling
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        render_error(e.message, :not_found)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render_error(e.record.errors.full_messages, :unprocessable_entity)
      end

      rescue_from ActionController::ParameterMissing do |e|
        render_error(e.message, :bad_request)
      end

      rescue_from ActionDispatch::Http::Parameters::ParseError do |e|
        render_error(e.message, :bad_request)
      end
    end

    def render_route_not_found
      render_error("Endpoint not found.", :not_found)
    end

    private

    def render_error(messages, status)
      errors = Array(messages).map { |m| ensure_period(m) }
      render json: { errors: errors }, status: status
    end

    def ensure_period(str)
      s = str.to_s.strip
      s.end_with?(".") ? s : "#{s}."
    end
  end
end
