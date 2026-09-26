source 'https://rubygems.org'

gem 'rails', '~> 7.1.0'
gem 'puma', '~> 6.4'
gem 'bcrypt', '~> 3.1.20'
gem 'kaminari', '~> 1.2.2'
gem 'pg', '~> 1.5'

group :development, :test do
  # SQLite is used as a lightweight backing store for the test suite so tests
  # can run without a live PostgreSQL server.
  gem 'sqlite3', '~> 1.7'
  # Rails 7.1's test_unit integration is incompatible with minitest 6.x
  # (the internal Minitest::Test#run signature changed). Pin to 5.x.
  gem 'minitest', '~> 5.20'
end
