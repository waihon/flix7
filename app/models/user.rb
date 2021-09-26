class User < ApplicationRecord
  before_save :format_email
  before_save :format_username

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
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

  scope :by_name, -> { order(name: :asc)  }

  scope :not_admins, -> { by_name.where(admin: false) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

private

  def format_email
    self.email = email.downcase
  end

  def format_username
    self.username = username.downcase
  end
end
