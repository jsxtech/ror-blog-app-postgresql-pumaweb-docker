class CategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.left_joins(:posts)
                          .select("categories.*, COUNT(posts.id) AS posts_count")
                          .group("categories.id")
                          .order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
