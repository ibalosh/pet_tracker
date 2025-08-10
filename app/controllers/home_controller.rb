class HomeController < ApplicationController
  def index
    render json: construct_api_success("Welcome to the Pet Tracker API. Check out endpoints at /api/v1.")
  end
end
