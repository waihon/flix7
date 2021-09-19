require 'rails_helper'

describe "A movie" do
  it "is released when the released on date is in the past" do
    movie = Movie.create(movie_attributes(released_on: 3.months.ago))

    expect(Movie.released).to include(movie)
  end

  it "is not released when the released on date is in the future" do
    movie = Movie.create(movie_attributes(released_on: 3.months.from_now))

    expect(Movie.released).not_to include(movie)
  end

  it "returns released movies ordered with the most recently-released movie first" do
    movie1 = Movie.create(movie_attributes(released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(released_on: 1.months.ago))

    expect(Movie.released).to eq([movie3, movie2, movie1])
  end

  it "returns movies with at least $300M total gross, ordered with the highest gross movie first" do
    movie1 = Movie.create(movie_attributes(total_gross: 300_000_000))
    movie2 = Movie.create(movie_attributes(total_gross: 299_999_999))
    movie3 = Movie.create(movie_attributes(total_gross: 300_000_001))

    expect(Movie.hits).to eq([movie3, movie1])
  end

  it "return movies with less than $225M total gross, ordered with the lowest grossing movie first" do
    movie1 = Movie.create(movie_attributes(total_gross: 224_999_999))
    movie2 = Movie.create(movie_attributes(total_gross: 225_000_000))
    movie3 = Movie.create(movie_attributes(total_gross: 224_999_998))

    expect(Movie.flops).to eq([movie3, movie1])
  end

  it "returns the last three movies that have been created, ordered with the most recently-added movie first" do
    movie1 = Movie.create(movie_attributes(title: "Movie 1"))
    movie2 = Movie.create(movie_attributes(title: "Movie 2"))
    movie3 = Movie.create(movie_attributes(title: "Movie 3"))
    movie4 = Movie.create(movie_attributes(title: "Movie 4"))

    expect(Movie.recently_added).to eq([movie4, movie3, movie2])
  end

  it "requires a title" do
    movie = Movie.new(title: "")

    movie.valid?  # populates errors

    expect(movie.errors[:title].any?).to eq(true)
  end

  it "requires a description" do
    movie = Movie.new(description: "")

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it "requires a released on date" do
    movie = Movie.new(released_on: "")

    movie.valid?

    expect(movie.errors[:released_on].any?).to eq(true)
  end

  it "requires a duration" do
    movie = Movie.new(duration: "")

    movie.valid?

    expect(movie.errors[:duration].any?).to eq(true)
  end

  it "requires a description over 24 characters" do
    movie = Movie.new(description: "X" * 24)

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it "accepts a $0 total gross" do
    movie = Movie.new(total_gross: 0.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "accepts a positive total gross" do
    movie = Movie.new(total_gross: 10_000_000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "rejects a negative total gross" do
    movie = Movie.new(total_gross: -10_000_000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(true)
  end

  it "accepts properly formatted image file names" do
    file_names = %w[e.png movie.png movie.jpg]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(false)
    end
  end

  it "rejects improperly formatted image file names" do
    file_names = %w[movie .jpg .png movie.gif movie.pdf movie.doc]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(true)
    end
  end

  it "accepts any rating that is in an approved list" do
    ratings = %w[G PG PG-13 R NC-17]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(false)
    end
  end

  it "rejects any rating that is not in the approved list" do
    ratings = %w[R-13 R-16 R-18 R-21]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(true)
    end
  end

  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)

    expect(movie.valid?).to eq(true)
  end

  it "has many reviews" do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it "deletes associated reviews" do
    movie = Movie.create(movie_attributes)
    user = User.create(user_attributes)

    movie.reviews.create(review_attributes(user: user))

    expect {
      movie.destroy
    }.to change(Review, :count).by(-1)
  end

  it "calculates the average number of review stars" do
    movie = Movie.create(movie_attributes)
    user = User.create(user_attributes)

    movie.reviews.create(review_attributes(stars: 1, user: user))
    movie.reviews.create(review_attributes(stars: 2, user: user))
    movie.reviews.create(review_attributes(stars: 3, user: user))
    movie.reviews.create(review_attributes(stars: 3, user: user))
    movie.reviews.create(review_attributes(stars: 3, user: user))
    movie.reviews.create(review_attributes(stars: 4, user: user))
    movie.reviews.create(review_attributes(stars: 4, user: user))
    movie.reviews.create(review_attributes(stars: 5, user: user))
    expect(movie.average_stars).to eq(3.125)
    expect(movie.average_stars_as_percent).to eq(62.50)
  end

  it "calcualtes the average stars as 0 if the movie doesn't have any reviews" do
    movie = Movie.create(movie_attributes)

    expect(movie.average_stars).to eq(0)
    expect(movie.average_stars_as_percent).to eq(0.00)
  end

  it "has fans" do
    movie = Movie.new(movie_attributes)
    fan1 = User.new(user_attributes(email: "larry@example.com"))
    fan2 = User.new(user_attributes(email: "moe@example.com"))

    movie.favorites.new(user: fan1)
    movie.favorites.new(user: fan2)

    expect(movie.fans).to include(fan1)
    expect(movie.fans).to include(fan2)
  end
end