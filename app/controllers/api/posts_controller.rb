class Api::PostsController < Api::BaseController
  def index
    posts = Post.published.includes(:user, :category).order(created_at: :desc).limit(100)
    render json: posts.as_json(
      only: [:id, :title, :content, :published, :views_count, :created_at, :updated_at],
      include: {
        user: { only: [:id, :email] },
        category: { only: [:id, :name] }
      }
    )
  end

  def show
    post = Post.published.includes(:user, :category, :comments).find(params[:id])
    render json: post.as_json(
      only: [:id, :title, :content, :published, :views_count, :created_at, :updated_at],
      include: {
        user: { only: [:id, :email] },
        category: { only: [:id, :name] },
        comments: { only: [:id, :body, :created_at] }
      }
    )
  end
end
