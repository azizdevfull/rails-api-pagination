class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]
  after_action { pagy_headers_merge(@pagy) if @pagy }
  # GET /posts
  def index
    @pagy, @posts = pagy(Post.all, :limit => 1)
    render json: {
      data: @posts,
      links: @pagy
    }
  end
  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.create!(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
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
    @post.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.permit(:title, :body)
    end
end
