class Movie < ApplicationRecord
  def self.released
    Movie.where("released_on < ?", Time.now).order(released_on: :desc)
  end

  def self.hits
    Movie.where("total_gross >= ?", 300_000_000).order(total_gross: :desc)
  end

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end
end
