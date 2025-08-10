module Api
  module V1
    class PetsController < ApplicationController
      before_action :find_pet, only: [ :show, :destroy, :update ]

      def index
        page_obj, data = paginate(Pet.includes(:species, :owner).all)
        render json: paginated_response("pets", PetSerializer.collection(data), page_obj)
      end

      def show
        render json: PetSerializer.new(@pet).as_json
      end

      def create
        pet = Pet.create!(pet_params)
        render json: PetSerializer.new(pet).as_json, status: :created
      end

      def update
        @pet.update!(pet_params)
        render json: PetSerializer.new(@pet).as_json
      end

      def destroy
        @pet.destroy
        head :no_content
      end

      private

      def find_pet
        @pet = Pet.includes(:species, :owner).find(params[:id])
      end

      def pet_params
        params.permit(:name, :species_id, :owner_id)
      end
    end
  end
end
