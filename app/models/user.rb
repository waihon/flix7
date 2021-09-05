class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :email, email: { mode: :strict, allow_blank: true }
  validates :email, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 10, allow_blank: true }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end
end
