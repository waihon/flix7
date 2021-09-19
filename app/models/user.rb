class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :email, presence: true
  validates :email, email: { mode: :strict, allow_blank: true }
  validates :email, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 10, allow_blank: true }
  validates :username, presence: true
  validates :username, format: {
    with: /\A[A-Z0-9]+\z/i,
    message: "must contains alphanumeric characters only",
    allow_blank: true
  }
  validates :username, uniqueness: { case_sensitive: false }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end
end
