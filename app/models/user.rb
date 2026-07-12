class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy

  before_validation { self.email = email&.downcase&.strip }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
end
