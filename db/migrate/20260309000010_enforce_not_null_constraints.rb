class EnforceNotNullConstraints < ActiveRecord::Migration[7.1]
  def up
    # The 4th argument to change_column_null backfills existing NULLs with the
    # given value before adding the constraint. This is portable across
    # PostgreSQL (production) and SQLite (test).
    change_column_null :posts, :published, false, false
    change_column_null :posts, :views_count, false, 0
    change_column_null :posts, :user_id, false

    change_column_null :comments, :post_id, false
    change_column_null :comments, :body, false
  end

  def down
    change_column_null :posts, :user_id, true
    change_column_null :posts, :published, true
    change_column_null :posts, :views_count, true

    change_column_null :comments, :post_id, true
    change_column_null :comments, :body, true
  end
end
