class Genre < ApplicationRecord
  before_save :set_slug

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  def to_param
    slug
  end

private

  def set_slug
    self.slug = name.parameterize
  end
end
