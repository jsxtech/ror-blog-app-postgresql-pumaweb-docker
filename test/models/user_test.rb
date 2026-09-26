require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user saves" do
    user = User.new(email: "new@example.com", password: "secret123")
    assert user.save
  end

  test "requires email" do
    user = User.new(password: "secret123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "requires unique email case-insensitively" do
    User.create!(email: "dup@example.com", password: "secret123")
    dup = User.new(email: "DUP@example.com", password: "secret123")
    assert_not dup.valid?
  end

  test "downcases and strips email before validation" do
    user = User.create!(email: "  MixedCase@Example.COM  ", password: "secret123")
    assert_equal "mixedcase@example.com", user.email
  end

  test "rejects invalid email format" do
    user = User.new(email: "not-an-email", password: "secret123")
    assert_not user.valid?
  end

  test "enforces minimum password length" do
    user = User.new(email: "short@example.com", password: "12345")
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 6 characters)"
  end

  test "destroying user destroys their posts" do
    user = users(:alice)
    assert_difference("Post.count", -Post.where(user: user).count) do
      user.destroy
    end
  end
end
