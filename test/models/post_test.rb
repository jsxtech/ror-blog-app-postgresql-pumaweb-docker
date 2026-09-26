require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid post saves" do
    post = posts(:published_post)
    assert post.valid?
  end

  test "requires title" do
    post = Post.new(content: "body", user: users(:alice))
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "requires content" do
    post = Post.new(title: "title", user: users(:alice))
    assert_not post.valid?
    assert_includes post.errors[:content], "can't be blank"
  end

  test "requires a user" do
    post = Post.new(title: "title", content: "body")
    assert_not post.valid?
  end

  test "title length capped at 200" do
    post = Post.new(title: "a" * 201, content: "body", user: users(:alice))
    assert_not post.valid?
  end

  test "content length capped at 10000" do
    post = Post.new(title: "title", content: "a" * 10001, user: users(:alice))
    assert_not post.valid?
  end

  test "published scope returns only published posts" do
    assert Post.published.all?(&:published?)
    assert_not_includes Post.published, posts(:draft_post)
  end

  test "drafts scope returns only unpublished posts" do
    assert Post.drafts.none?(&:published?)
  end

  test "category is optional" do
    post = Post.new(title: "t", content: "c", user: users(:alice))
    assert post.valid?
  end
end
