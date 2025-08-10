module Api
  module V1
    class SpeciesController < ApplicationController
      before_action :find_species, only: [ :show, :update, :destroy ]

      def index
        page_obj, data = paginate(Species.all)
        render json: paginated_response("species", SpeciesSerializer.collection(data), page_obj)
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
        render json: SpeciesSerializer.new(@species).as_json
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
  end
end
