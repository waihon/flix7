class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }
  has_secure_password
end
