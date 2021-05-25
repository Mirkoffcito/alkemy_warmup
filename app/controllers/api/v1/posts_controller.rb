class Api::V1::PostsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_user!
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :order_params

  has_scope :title
  has_scope :category

  rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed

  # GET /posts
  def index
    if @user.admin?
      @posts = Post.all
    else
      # Sólo hace un query de los posts que no han sufrido un soft_delete
      @posts = current_api_user.posts.kept

    end
    render json: (apply_scopes(@posts)).order(created_at: @order), each_serializer: PostsSerializer
    #render json: @user.role
  end

  # GET /posts/1
  def show
    if @post.kept?
      render json: @post, serializer: PostSerializer
    else
      # Si el post sufrio de un soft_delete, devuelve un error 404 not found
      render json: @post.errors, status: :not_found
    end
  end

  # POST /posts
  def create
    @post = current_api_user.posts.new(post_params)

    if @post.save
      render json: @post, serializer: PostSerializer, status: :created, location: api_post_url(@post)
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

    # Renders custom error when record is not found instead of 404
    def not_destroyed
      error = 'No pudo encontrarse un post con esa ID'
      render json: error, status: :unprocessable_entity
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      if @user.admin?
        @post = Post.find(params[:id])
      else
        @post = current_api_user.posts.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :category_id,)
    end

    def order_params
      @order = params.fetch(:order, "DESC")  # Captura el parametro ASC o DESC pasado en la URL, si no se pasa ningún parametro, setea ASC por default.
    end

    def set_user
      @user = current_api_user
    end

end
