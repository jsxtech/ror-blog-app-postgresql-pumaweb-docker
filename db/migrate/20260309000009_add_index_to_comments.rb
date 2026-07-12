class AddIndexToComments < ActiveRecord::Migration[7.1]
  def change
    add_index :comments, :post_id, if_not_exists: true
  end
end
