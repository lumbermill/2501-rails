class BlogsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_blog, only: %i[ show edit update destroy ]

  # GET /blogs or /blogs.json
  def index
    if authenticated?
      case params[:filter]
      when 'published'
        @blogs = Blog.published.order(created_at: :desc)
      when 'draft'
        @blogs = Blog.draft.order(created_at: :desc)
      when 'all'
        @blogs = Blog.all.order(created_at: :desc)
      else
        @blogs = Blog.all.order(created_at: :desc)
      end
    else
      @blogs = Blog.published.order(created_at: :desc)
    end
  end

  # GET /blogs/1 or /blogs/1.json
  def show
    unless @blog.published || authenticated?
      redirect_to blogs_path, alert: "このブログ記事は非公開です。"
    end
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs or /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1 or /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: "Blog was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1 or /blogs/1.json
  def destroy
    @blog.destroy!

    respond_to do |format|
      format.html { redirect_to blogs_path, notice: "Blog was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.expect(blog: [ :title, :content, :published ])
    end
end
