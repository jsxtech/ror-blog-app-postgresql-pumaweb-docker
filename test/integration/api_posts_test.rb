require "test_helper"

class Api::PostsTest < ActionDispatch::IntegrationTest
  test "index returns only published posts as JSON" do
    get "/api/posts"
    assert_response :success
    body = JSON.parse(response.body)
    titles = body.map { |p| p["title"] }
    assert_includes titles, posts(:published_post).title
    assert_not_includes titles, posts(:draft_post).title
  end

  test "index does not leak user email (PII)" do
    get "/api/posts"
    assert_response :success
    body = JSON.parse(response.body)
    body.each do |post|
      assert post.key?("user"), "expected user association in payload"
      assert_not post["user"].key?("email"), "user email must not be exposed"
      assert post["user"].key?("id")
    end
    assert_not_includes response.body, "@example.com"
  end

  test "show returns a single published post without email" do
    post = posts(:published_post)
    get "/api/posts/#{post.id}"
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal post.title, body["title"]
    assert_not body["user"].key?("email")
    assert body["comments"].is_a?(Array)
  end

  test "show returns 404 for draft post" do
    get "/api/posts/#{posts(:draft_post).id}"
    assert_response :not_found
    assert_equal "Not found", JSON.parse(response.body)["error"]
  end

  test "show returns 404 for missing post" do
    get "/api/posts/999999"
    assert_response :not_found
  end
end
