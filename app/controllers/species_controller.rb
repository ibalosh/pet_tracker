class SpeciesController < ApplicationController
  before_action :find_species, only: [ :show, :update, :destroy ]
  def index
    page_obj, data = pagy(Species.all)
    render json: paged_response(SpeciesSerializer.collection(data), page_obj)
  end

  def show
    render json: SpeciesSerializer.new(@species)
  end

  def create
    species = Species.create!(species_params)
    render json: SpeciesSerializer.new(species).as_json, status: :created
  end

  def update
    @species.update!(species_params)
    render json: SpeciesSerializer.new(@species).as_json, status: :ok
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
