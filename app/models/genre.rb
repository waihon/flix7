class Genre < ApplicationRecord
  before_save :set_slug

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  has_one_attached :main_image

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  validate :acceptable_image

  def to_param
    slug
  end

private

  def set_slug
    self.slug = name.parameterize
  end

  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, "must be a JPEG or PNG")
    end
  end
end
