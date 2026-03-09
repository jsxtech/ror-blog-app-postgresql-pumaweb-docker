class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true, length: { maximum: 10000 }

  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }
  scope :popular, -> { order(views_count: :desc) }
end
