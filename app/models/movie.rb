class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :critics, through: :reviews, source: :user
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :title, presence: true
  validates :description, presence: true
  validates :description, length: { minimum: 25 }, allow_blank: true
  RATINGS = %w[G PG PG-13 R NC-17]
  validates :rating, inclusion: { in: RATINGS }
  validates :released_on, presence: true
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  scope :released, -> { where("released_on < ?", Time.now).order(released_on: :desc) }

  scope :hits, -> { where("total_gross >= ?", 300_000_000).order(total_gross: :desc) }

  scope :flops, -> { where("total_gross < ?", 225_000_000).order(total_gross: :asc) }

  scope :recently_added, -> { order(created_at: :desc).limit(3) }

  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }

  scope :rated, ->(rating) { released.where(rating: rating) }

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars
    reviews.average(:stars) || 0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100.0
  end
end
