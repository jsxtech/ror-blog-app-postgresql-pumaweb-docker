require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category saves" do
    assert Category.new(name: "Sports").save
  end

  test "requires name" do
    assert_not Category.new.valid?
  end

  test "name must be unique" do
    Category.create!(name: "Unique")
    assert_not Category.new(name: "Unique").valid?
  end

  test "name length capped at 50" do
    assert_not Category.new(name: "a" * 51).valid?
  end

  test "destroying category nullifies posts" do
    category = categories(:tech)
    post = posts(:published_post)
    assert_equal category, post.category
    category.destroy
    assert_nil post.reload.category_id
  end
end
