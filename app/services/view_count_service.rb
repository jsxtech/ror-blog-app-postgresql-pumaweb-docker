class ViewCountService
  # Increments a post's view count at most once per session, excluding the
  # post's own author. Returns true if the count was incremented.
  def self.increment(post, session, current_user)
    return false if current_user == post.user

    session_key = "viewed_post_#{post.id}"
    return false if session[session_key]

    Post.where(id: post.id).update_all("views_count = views_count + 1")
    session[session_key] = true
    # Keep the in-memory record in sync so the current request renders the
    # up-to-date count without an extra reload query.
    post.views_count = post.views_count.to_i + 1
    true
  end
end
