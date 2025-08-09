class ApplicationController < ActionController::API
  include Pagy::Backend
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :render_bad_request

  def render_bad_request(exception)
    render_error(exception.message, :bad_request)
  end

  def render_route_not_found
    render_error("Endpoint not found.", :not_found)
  end

  def render_record_not_found(exception)
    render_error(exception.message, :not_found)
  end

  def render_unprocessable_entity(exception)
    render_error(exception.record.errors.full_messages, :unprocessable_entity)
  end

  def render_error(messages, status)
    render json: { errors: Array.wrap(messages) }, status:
  end

  def paged_response(resource_name, data, page_obj)
    {
      resource_name => data,
      meta: {
        page: page_obj.page,
        items_in_page: page_obj.in,
        total_pages:  page_obj.pages,
        total_items:  page_obj.count
      }
    }
  end

  private

  def construct_api_success(message)
    { message: message }
  end
end
