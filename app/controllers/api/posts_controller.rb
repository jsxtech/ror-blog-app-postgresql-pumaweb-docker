class Api::PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    posts = Post.published.includes(:user, :category).order(created_at: :desc).limit(100)
    render json: posts
  end

  def show
    post = Post.published.includes(:comments).find(params[:id])
    render json: post
  end

  private

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end
end
