class ApplicationController < ActionController::API
  include Pagy::Backend
  include Api::ErrorHandling

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
