class Api::V1::PostsController < ApplicationController
  before_action :authenticate_api_user!
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :order_params

  has_scope :title
  has_scope :category

  # GET /posts
  def index
    # Sólo hace un query de los posts que no han sufrido un soft_delete
    @posts = current_api_user.posts.kept

    render json: (apply_scopes(@posts)).order(created_at: @order), each_serializer: PostsSerializer
  end

  # GET /posts/1
  def show
    if @post.kept?
      render json: @post, each_serializer: PostSerializer
    else
      # Si el post sufrio de un soft_delete, devuelve un error 404 not found
      render json: @post.errors, status: :not_found
    end
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
    # it will soft_delete records instead of completely deleting them.
    @post.discard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_api_user.posts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :category_id,)
    end

    def order_params
      @order = params.fetch(:order, "DESC")  # Captura el parametro ASC o DESC pasado en la URL, si no se pasa ningún parametro, setea ASC por default.
    end
end
