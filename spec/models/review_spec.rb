require 'rails_helper'

describe "A review" do
  context "past_n_days query" do
    before do
      movie = Movie.create!(movie_attributes)
      user = User.create!(user_attributes)
      @review1 = movie.reviews.create!(review_attributes(created_at: 90.days.ago, user: user))
      @review2 = movie.reviews.create!(review_attributes(created_at: 60.days.ago, user: user))
      @review3 = movie.reviews.create!(review_attributes(created_at: 30.days.ago, user: user))
      @review4 = movie.reviews.create!(review_attributes(created_at: 29.days.ago, user: user))
      @review5 = movie.reviews.create!(review_attributes(created_at: 7.days.ago, user: user))
      @review6 = movie.reviews.create!(review_attributes(created_at: 6.days.ago, user: user))
      @review7 = movie.reviews.create!(review_attributes(created_at: 3.days.ago, user: user))
      @review8 = movie.reviews.create!(review_attributes(created_at: 1.days.ago, user: user))
      @review9 = movie.reviews.create!(review_attributes(created_at: 1.hours.ago, user: user))
    end

    it "returns reviews written in the past specified number of days ordered with the most recent review first" do
      # The expected result doesn't include @review3 because by the time the query is run, "30 days ago" 
      # would have become "more than 30 days ago".
      expect(Review.past_n_days(30)).to eq([@review9, @review8, @review7, @review6, @review5, @review4])
    end

    it "returns reviews written in the past default of 7 days ordered with the most recent review first" do
      # The expected result doesn't include @review5 because by the time the query is run, "7 days ago" 
      # would have become "more than 7 days ago".
      expect(Review.past_n_days).to eq([@review9, @review8, @review7, @review6])
    end
  end

  it "belongs to a movie" do
    movie = Movie.create(movie_attributes)

    review = movie.reviews.new(review_attributes)

    expect(review.movie).to eq(movie)
  end

  it "belongs to a user" do
    user = User.create(user_attributes)

    review = user.reviews.new(review_attributes)

    expect(review.user).to eq(user)
  end

  it "with example attributes is valid" do
    movie = Movie.create(movie_attributes)
    user = User.create(user_attributes)

    review = movie.reviews.new(review_attributes(user: user))

    expect(review.valid?).to eq(true)
  end

  it "requires a user" do
    review = Review.new(user: nil)

    review.valid? # populates errors

    expect(review.errors[:user].any?).to eq(true)
  end

  it "requires a movie" do
    review = Review.new(movie: nil)

    review.valid?

    expect(review.errors[:movie].any?).to eq(true)
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