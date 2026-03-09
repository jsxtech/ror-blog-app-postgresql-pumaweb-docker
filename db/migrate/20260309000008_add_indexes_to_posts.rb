class AddIndexesToPosts < ActiveRecord::Migration[7.1]
  def change
    add_index :posts, :user_id
    add_index :posts, :category_id
    add_index :posts, :published
    add_index :posts, :created_at
  end
end
