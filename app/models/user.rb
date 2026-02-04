class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites, source: :book
  has_one_attached :avatar
  has_one_attached :profile_image
  has_many :comments, dependent: :destroy

    # フォローする側
  has_many :relationships,
         foreign_key: :follower_id,
         dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :active_relationships,
           class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :followings,
           through: :active_relationships,
           source: :followed

  # フォローされる側
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :passive_relationships,
           class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :followers,
           through: :passive_relationships,
           source: :follower

  # 自分がフォローしているユーザー
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  # 自分をフォローしているユーザー
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(user)
    followings << user
  end

  def unfollow(user)
    followings.destroy(user)
  end

  def following?(user)
    followings.include?(user)
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 2, maximum: 20 }

  validates :introduction,
            length: { maximum: 50 }
end
