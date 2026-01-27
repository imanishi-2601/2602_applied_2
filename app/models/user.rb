class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy
  has_one_attached :avatar
  has_one_attached :profile_image

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 2, maximum: 20 }

  validates :introduction,
            length: { maximum: 50 }
end
