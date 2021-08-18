require 'rails_helper'

describe "A review" do
  it "belongs to a movie" do
    movie = Movie.create(movie_attributes)

    review = movie.reviews.new(review_attributes)

    expect(review.movie).to eq(movie)
  end

  it "with example attributes is valid" do
    movie = Movie.create(movie_attributes)

    review = movie.reviews.new(review_attributes)

    expect(review.valid?).to eq(true)
  end

  it "requires a name" do
    review = Review.new(name: "")

    review.valid? # populates errors

    expect(review.errors[:name].any?).to eq(true)
  end


  it "requires a comment" do
    review = Review.new(comment: "")

    review.valid?

    expect(review.errors[:comment].any?).to eq(true)
  end

  it "requires a comment over 3 characters" do
    review = Review.new(comment: "X" * 3)

    review.valid?

    expect(review.errors[:comment].any?).to eq(true)
  end

  it "accepts star values of 1 through 5" do
    stars = [1, 2, 3, 4, 5]
    stars.each do |star|
      review = Review.new(stars: star)

      review.valid?

      expect(review.errors[:stars].any?).to eq(false)
    end
  end

  it "rejects invalid star values" do
    stars = [-1, 0, 6]
    stars.each do |star|
      review = Review.new(stars: star)

      review.valid?

      expect(review.errors[:stars].any?).to eq(true)
      expect(review.errors[:stars].first).to eq("must be between 1 and 5")
    end
  end

  it "calculates stars as percent" do
    stars = Review::STARS
    percent = [20.0, 40.0, 60.0, 80.0, 100.0]
    stars.each_with_index do |star, index|
      review = Review.new(stars: star)
      expect(review.stars_as_percent).to eq(percent[index])
    end
  end
end