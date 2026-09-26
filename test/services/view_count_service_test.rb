require "test_helper"

class ViewCountServiceTest < ActiveSupport::TestCase
  setup do
    @post = posts(:bobs_post) # authored by bob
    @owner = users(:bob)
    @viewer = users(:alice)
  end

  test "does not increment for the post's owner" do
    session = {}
    assert_no_difference("@post.reload.views_count") do
      result = ViewCountService.increment(@post, session, @owner)
      assert_equal false, result
    end
  end

  test "increments once for a non-owner and marks the session" do
    session = {}
    assert_difference("@post.reload.views_count", 1) do
      result = ViewCountService.increment(@post, session, @viewer)
      assert_equal true, result
    end
    assert session["viewed_post_#{@post.id}"]
  end

  test "does not increment twice within the same session" do
    session = {}
    ViewCountService.increment(@post, session, @viewer)
    assert_no_difference("@post.reload.views_count") do
      result = ViewCountService.increment(@post, session, @viewer)
      assert_equal false, result
    end
  end

  test "increments for anonymous (nil) users" do
    session = {}
    assert_difference("@post.reload.views_count", 1) do
      ViewCountService.increment(@post, session, nil)
    end
  end

  test "updates the in-memory views_count so it renders correctly" do
    original = @post.views_count
    ViewCountService.increment(@post, {}, @viewer)
    assert_equal original + 1, @post.views_count
  end
end
