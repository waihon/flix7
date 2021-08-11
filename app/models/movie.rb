class Movie < ApplicationRecord
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

  def self.released
    Movie.where("released_on < ?", Time.now).order(released_on: :desc)
  end

  def self.hits
    Movie.where("total_gross >= ?", 300_000_000).order(total_gross: :desc)
  end

  def self.flops
    Movie.where("total_gross < ?", 225_000_000).order(total_gross: :asc)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end
end
