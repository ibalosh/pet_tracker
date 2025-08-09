class OwnersController < ApplicationController
  before_action :find_owner, only: [ :show, :update, :destroy ]
  def index
    page_obj, data = pagy(Owner.all)
    render json: paged_response("owners", OwnerSerializer.collection(data), page_obj)
  end

  def show
    render json: OwnerSerializer.new(@owner)
  end

  def create
    owner = Owner.create!(owner_params)
    render json: OwnerSerializer.new(owner), status: :created
  end

  def update
    @owner.update!(owner_params)
    render json: OwnerSerializer.new(@owner)
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
