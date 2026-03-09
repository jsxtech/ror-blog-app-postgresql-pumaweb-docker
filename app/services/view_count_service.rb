class ViewCountService
  def self.increment(post, session, current_user)
    return if current_user == post.user
    
    session_key = "viewed_post_#{post.id}"
    return if session[session_key]
    
    Post.where(id: post.id).update_all("views_count = views_count + 1")
    session[session_key] = true
  end
end
