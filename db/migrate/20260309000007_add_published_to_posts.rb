class AddPublishedToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :published, :boolean, default: false
    add_column :posts, :views_count, :integer, default: 0
  end
end
