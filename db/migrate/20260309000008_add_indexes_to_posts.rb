class AddIndexesToPosts < ActiveRecord::Migration[7.1]
  def change
    add_index :posts, :user_id, if_not_exists: true
    add_index :posts, :category_id, if_not_exists: true
    add_index :posts, :published
    add_index :posts, :created_at
  end
end
