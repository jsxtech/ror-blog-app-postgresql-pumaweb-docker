class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @posts = if current_user
      Post.where(published: true).or(Post.where(user: current_user)).includes(:user, :category, :comments)
    else
      Post.published.includes(:user, :category, :comments)
    end
    @posts = @posts.where(category_id: params[:category_id]) if params[:category_id].present?
    if params[:q].present?
      query = Post.sanitize_sql_like(params[:q])
      @posts = @posts.where("title ILIKE ? OR content ILIKE ?", "%#{query}%", "%#{query}%")
    end
    @posts = @posts.order(created_at: :desc).page(params[:page]).per(ApplicationHelper::POSTS_PER_PAGE)
    @categories = Category.all
  end

  def show
    if !@post.published && (!current_user || @post.user != current_user)
      redirect_to posts_path, alert: 'Post not published.' and return
    end
    ViewCountService.increment(@post, session, current_user)
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post created.'
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post updated.'
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post deleted.'
  end

  private

  def set_post
    @post = Post.includes(:user, :category, :comments).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'Post not found.'
  end

  def authorize_user
    return if performed?
    redirect_to posts_path, alert: 'Not authorized.' unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :published)
  end
end
