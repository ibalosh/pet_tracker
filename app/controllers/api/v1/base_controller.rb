module Api
  module V1
    # Used for storing version specific reusable logic
    class BaseController < ApplicationController
      before_action { request.format = :json }
    end
  end
end
