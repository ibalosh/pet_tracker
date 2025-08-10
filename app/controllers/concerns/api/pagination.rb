module Api
  module Pagination
    extend ActiveSupport::Concern

    included do
      include Pagy::Backend
    end

    def paginate(scope)
      pagy(scope)
    end

    def paginated_response(resource_name, records, pagy_obj)
      {
        resource_name => records,
        meta: {
          page: pagy_obj.page,
          items_in_page: pagy_obj.in,
          total_pages:  pagy_obj.pages,
          total_items:  pagy_obj.count
        }
      }
    end
  end
end
