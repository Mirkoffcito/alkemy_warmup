class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_api_user!
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories, each_serializer: CategoriesSerializer
  end

  # GET /categories/1
  def show
    render json: @category, serializer: CategoriesSerializer
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    authorize @category

    if @category.save
      render json: @category, serializer: CategoriesSerializer, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    authorize @category
    if @category.update(category_params)
      render json: @category, serializer: CategoriesSerializer
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    authorize @category
    @category.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end
