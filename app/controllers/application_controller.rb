class ApplicationController < ActionController::API
  include Api::ErrorHandling
  include Api::Pagination

  private

  def construct_api_success(message)
    { message: message }
  end
end
