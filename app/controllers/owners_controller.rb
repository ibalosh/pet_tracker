class OwnersController < ApplicationController
  before_action :find_owner, only: [ :show, :update, :destroy ]
  def index
    owners = Owner.all
    pagination_details, paginated_data = pagy(owners)

    render json: paginated_response("owners", paginated_data.as_json, pagination_details)
  end

  def show
    render json: @owner
  end

  def create
    owner = Owner.create!(owner_params)
    render json: owner, status: :created
  end

  def update
    @owner.update!(owner_params)
    render json: @owner, status: :ok
  end

  def destroy
    @owner.destroy
    head :no_content
  end

  private

  def find_owner
    @owner = Owner.find(params[:id])
  end

  def owner_params
    params.permit(:name, :email)
  end
end
