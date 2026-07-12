class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to @post, notice: 'Comment added.'
    else
      redirect_to @post, alert: @comment.errors.full_messages.join(', ')
    end
  end

  def destroy
    redirect_to @comment.post, alert: 'Not authorized.' and return unless @comment.post.user == current_user
    @comment.destroy
    redirect_to @comment.post, notice: 'Comment deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
    unless @post.published || @post.user == current_user
      redirect_to posts_path, alert: 'Post not found.' and return
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'Post not found.'
  end

  def set_comment
    @comment = Comment.find_by!(post_id: params[:post_id], id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'Comment not found.'
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
