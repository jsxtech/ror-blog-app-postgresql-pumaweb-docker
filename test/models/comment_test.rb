require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid comment saves" do
    comment = Comment.new(body: "Nice", post: posts(:published_post))
    assert comment.save
  end

  test "requires body" do
    comment = Comment.new(post: posts(:published_post))
    assert_not comment.valid?
  end

  test "requires a post" do
    comment = Comment.new(body: "orphan")
    assert_not comment.valid?
  end

  test "body length capped at 1000" do
    comment = Comment.new(body: "a" * 1001, post: posts(:published_post))
    assert_not comment.valid?
  end

  test "destroying post destroys its comments" do
    post = posts(:published_post)
    assert_difference("Comment.count", -post.comments.count) do
      post.destroy
    end
  end
end
