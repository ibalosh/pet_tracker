class PetsController < ApplicationController
  before_action :find_pet, only: [ :show, :update, :destroy ]
  def index
    page_obj, data = pagy(Pet.includes(:species, :owner).all)
    render json: paged_response(data, page_obj)
  end

  def show
    render json: @pet
  end

  def create
    pet = Pet.create!(pet_params)
    render json: pet, status: :created
  end

  def update
    @pet.update!(pet_params)
    render json: @pet, status: :ok
  end

  def destroy
    @pet.destroy
    head :no_content
  end

  private

  def find_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.permit(:name, :species_id, :owner_id)
  end
end
