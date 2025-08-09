class SpeciesController < ApplicationController
  before_action :find_species, only: [ :show, :update, :destroy ]
  def index
    page_obj, data = pagy(Species.all)
    render json: paged_response(data, page_obj)
  end

  def show
    render json: @species
  end

  def create
    species = Species.create!(species_params)
    render json: species, status: :created
  end

  def update
    @species.update!(species_params)
    render json: @species, status: :ok
  end

  def destroy
    @species.destroy
    head :no_content
  end

  private

  def find_species
    @species = Species.find(params[:id])
  end

  def species_params
    params.permit(:name)
  end
end
