class ApplicationController < ActionController::API
  include Pagy::Backend
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  def render_route_not_found
    render json: construct_api_error("Endpoint not found."), status: :not_found
  end

  def render_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def paginated_response(data_name, json, pagy)
    {
      data_name => json,
      pagination: {
        current_page: pagy.page,
        total_pages:  pagy.pages,
        total_count:  pagy.count
      }
    }
  end

  private

  def construct_api_success(message)
    { message: message }
  end

  def construct_api_error(message)
    { error: { message: message } }
  end
end
