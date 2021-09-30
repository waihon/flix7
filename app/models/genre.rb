class Genre < ApplicationRecord
  before_save :set_slug

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  has_one_attached :main_image

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def to_param
    slug
  end

private

  def set_slug
    self.slug = name.parameterize
  end
end
