require "test_helper"

class AuthFlowTest < ActionDispatch::IntegrationTest
  test "signup creates a user and logs in" do
    assert_difference("User.count", 1) do
      post users_path, params: { user: { email: "signup@example.com", password: "password123", password_confirmation: "password123" } }
    end
    assert_redirected_to root_path
  end

  test "login with valid credentials succeeds" do
    post session_path, params: { email: users(:alice).email, password: "password123" }
    assert_redirected_to root_path
  end

  test "login is case-insensitive on email" do
    post session_path, params: { email: "ALICE@EXAMPLE.COM", password: "password123" }
    assert_redirected_to root_path
  end

  test "login is whitespace-tolerant on email" do
    post session_path, params: { email: "  alice@example.com  ", password: "password123" }
    assert_redirected_to root_path
  end

  test "login with invalid credentials fails" do
    post session_path, params: { email: users(:alice).email, password: "wrong" }
    assert_response :unprocessable_entity
  end

  test "logout clears session" do
    post session_path, params: { email: users(:alice).email, password: "password123" }
    delete session_path
    assert_redirected_to root_path
  end
end

class PostAuthorizationTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end

  test "guest cannot access new post form" do
    get new_post_path
    assert_redirected_to new_session_path
  end

  test "non-owner cannot edit another user's post" do
    login_as(users(:bob))
    get edit_post_path(posts(:published_post)) # owned by alice
    assert_redirected_to posts_path
  end

  test "owner can edit their own post" do
    login_as(users(:alice))
    get edit_post_path(posts(:published_post))
    assert_response :success
  end

  test "non-owner cannot delete another user's post" do
    login_as(users(:bob))
    assert_no_difference("Post.count") do
      delete post_path(posts(:published_post))
    end
    assert_redirected_to posts_path
  end

  test "draft post is not shown to non-owner" do
    login_as(users(:bob))
    get post_path(posts(:draft_post)) # alice's draft
    assert_redirected_to posts_path
  end

  test "owner can view their own draft" do
    login_as(users(:alice))
    get post_path(posts(:draft_post))
    assert_response :success
  end
end

class CommentAuthorizationTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end

  test "guest cannot comment" do
    assert_no_difference("Comment.count") do
      post post_comments_path(posts(:published_post)), params: { comment: { body: "hi" } }
    end
    assert_redirected_to new_session_path
  end

  test "logged in user can comment" do
    login_as(users(:bob))
    assert_difference("Comment.count", 1) do
      post post_comments_path(posts(:published_post)), params: { comment: { body: "nice" } }
    end
  end

  test "only post owner can delete comments" do
    login_as(users(:bob)) # not the post owner
    assert_no_difference("Comment.count") do
      delete post_comment_path(posts(:published_post), comments(:first_comment))
    end
  end
end
