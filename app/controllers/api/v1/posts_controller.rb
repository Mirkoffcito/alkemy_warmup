class Api::V1::PostsController < ApplicationController
  before_action :authenticate_api_user!
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :order_params

  has_scope :title
  has_scope :category

  # GET /posts
  def index
    @posts = current_api_user.posts.all

    render json: (apply_scopes(@posts)).order(created_at: @order), each_serializer: PostsSerializer
  end

  # GET /posts/1
  def show
    render json: @post, each_serializer: PostSerializer
  end

  # POST /posts
  def create
    @post = current_api_user.posts.new(post_params)

    if @post.save
      render json: @post, status: :created, location: api_post_url(@post)
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_api_user.posts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :category_id)
    end

    def order_params
      @order = params.fetch(:order, "DESC")  # Captura el parametro ASC o DESC pasado en la URL, si no se pasa ningún parametro, setea ASC por default.
    end
end
