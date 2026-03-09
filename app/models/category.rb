class Category < ApplicationRecord
  has_many :posts, dependent: :nullify
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
