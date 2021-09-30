require 'rails_helper'

describe "A movie" do
  context "released query" do
    it "returns movies with released on date in the past" do
      movie = Movie.create(movie_attributes(title: "Movie 1", released_on: 3.months.ago))

      expect(Movie.released).to include(movie)
    end

    it "does not return movies with released on date in the future" do
      movie = Movie.create(movie_attributes(title: "Movie 1", released_on: 3.months.from_now))

      expect(Movie.released).not_to include(movie)
    end

    it "returns released movies ordered with the most recently-released movie first" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1", released_on: 3.months.ago))
      movie2 = Movie.create(movie_attributes(title: "Movie 2", released_on: 2.months.ago))
      movie3 = Movie.create(movie_attributes(title: "Movie 3", released_on: 1.months.ago))

      expect(Movie.released).to eq([movie3, movie2, movie1])
    end
  end

  context "hits query" do
    it "returns released movies with at least $300M total gross, ordered with the highest gross movie first" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1", total_gross: 300_000_000, released_on: 3.months.ago))
      movie2 = Movie.create(movie_attributes(title: "Movie 2", total_gross: 299_999_999, released_on: 2.months.ago))
      movie3 = Movie.create(movie_attributes(title: "Movie 3", total_gross: 300_000_001, released_on: 1.month.ago))
      movie4 = Movie.create(movie_attributes(title: "Movie 4", total_gross: 300_000_002, released_on: 1.day.from_now))

      expect(Movie.hits).to eq([movie3, movie1])
    end
  end

  context "flops query" do
    it "return released movies with less than $225M total gross, ordered with the lowest grossing movie first" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1", total_gross: 224_999_999, released_on: 3.months.ago))
      movie2 = Movie.create(movie_attributes(title: "Movie 2", total_gross: 225_000_000, released_on: 2.months.ago))
      movie3 = Movie.create(movie_attributes(title: "Movie 3", total_gross: 224_999_998, released_on: 1.month.ago))
      movie4 = Movie.create(movie_attributes(title: "Movie 4", total_gross: 224_999_997, released_on: 1.day.from_now))

      expect(Movie.flops).to eq([movie3, movie1])
    end
  end

  context "recently_added query" do
    it "returns the last three movies that have been created, ordered with the most recently-added movie first" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1"))
      movie2 = Movie.create(movie_attributes(title: "Movie 2"))
      movie3 = Movie.create(movie_attributes(title: "Movie 3"))
      movie4 = Movie.create(movie_attributes(title: "Movie 4"))

      expect(Movie.recently_added).to eq([movie4, movie3, movie2])
    end
  end

  context "upcoming query" do
    it "returns the movies with a released on date in the future" do
      movie1 = Movie.create!(movie_attributes(title: "Movie 1", released_on: 3.months.ago))
      movie2 = Movie.create!(movie_attributes(title: "Movie 2", released_on: 3.months.from_now))

      expect(Movie.upcoming).to eq([movie2])
    end
  end

  context "rated query" do
    it "returns released movies with the specified rating" do
      movie1 = Movie.create!(movie_attributes(title: "Movie 1", released_on: 3.months.ago, rating: "PG"))
      movie2 = Movie.create!(movie_attributes(title: "Movie 2", released_on: 3.months.ago, rating: "PG-13"))
      movie3 = Movie.create!(movie_attributes(title: "Movie 3", released_on: 1.month.from_now, rating: "PG"))

      expect(Movie.rated("PG")).to eq([movie1])
    end
  end

  context "recent query" do
    before do
      @movie1 = Movie.create!(movie_attributes(title: "Movie 1", released_on: 3.months.ago))
      @movie2 = Movie.create!(movie_attributes(title: "Movie 2", released_on: 2.months.ago))
      @movie3 = Movie.create!(movie_attributes(title: "Movie 3", released_on: 1.month.ago))
      @movie4 = Movie.create!(movie_attributes(title: "Movie 4", released_on: 1.week.ago))
      @movie5 = Movie.create!(movie_attributes(title: "Movie 5", released_on: 1.day.ago))
      @movie6 = Movie.create!(movie_attributes(title: "Movie 6", released_on: 1.hour.ago))
      @movie7 = Movie.create!(movie_attributes(title: "Movie 7", released_on: 1.day.from_now))
    end

    it "returns a specified number of released movies ordered with the most recent movie first" do
      expect(Movie.recent(2)).to eq([@movie6, @movie5])
    end

    it "returns a default of 5 released movies ordered with the most recent movie first" do
      expect(Movie.recent).to eq([@movie6, @movie5, @movie4, @movie3, @movie2])
    end
  end

  context "grossed_greater_than query" do
    it "returns released movies with total gross greater than a specified amount" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1", total_gross: 500_000_001, released_on: 3.months.ago))
      movie2 = Movie.create(movie_attributes(title: "Movie 2", total_gross: 499_999_999, released_on: 2.months.ago))
      movie3 = Movie.create(movie_attributes(title: "Movie 3", total_gross: 500_000_002, released_on: 1.month.ago))
      movie4 = Movie.create(movie_attributes(title: "Movie 4", total_gross: 500_000_003, released_on: 1.day.from_now))

      high_grossed = Movie.grossed_greater_than(500_000_000)
      expect(high_grossed).to include(movie3)
      expect(high_grossed).to include(movie1)
    end
  end

  context "grossed_less_than query" do
    it "returns released movies with total gross less than a specified amount" do
      movie1 = Movie.create(movie_attributes(title: "Movie 1", total_gross: 24_999_999, released_on: 3.months.ago))
      movie2 = Movie.create(movie_attributes(title: "Movie 2", total_gross: 25_000_000, released_on: 2.months.ago))
      movie3 = Movie.create(movie_attributes(title: "Movie 3", total_gross: 24_999_998, released_on: 1.month.ago))
      movie4 = Movie.create(movie_attributes(title: "Movie 4", total_gross: 24_999_997, released_on: 1.day.from_now))

      low_grossed = Movie.grossed_less_than(25_000_000)
      expect(low_grossed).to include(movie3)
      expect(low_grossed).to include(movie1)
    end
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

  it "accepts image files with valid content type" do
    files = %w[png_file jpg_file]
    files.each do |file|
      movie = Movie.new
      # file methods are defined in spec/support/active_storage.rb
      movie.main_image.attach(send(file))
      movie.valid?
      expect(movie.errors[:main_image].any?).to eq(false)
    end
  end

  it "rejects image files with invalid content type" do
    files = %w[gif_file tiff_file pdf_file]
    files.each do |file|
      movie = Movie.new
      # file methods are defined in spec/support/active_storage.rb
      movie.main_image.attach(send(file))
      movie.valid?
      expect(movie.errors[:main_image].any?).to eq(true)
    end
  end

  it "rejects image files over 1 MB" do
    movie = Movie.new
    movie.main_image.attach(big_image_file)

    movie.valid?

    expect(movie.errors[:main_image].first).to eq("is too big")
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

  it "has many reviews ordered with the most recent review first" do
    user = User.create!(user_attributes)
    movie = Movie.create!(movie_attributes)

    review1 = movie.reviews.create!(review_attributes(created_at: 30.days.ago, user: user))
    review2 = movie.reviews.create!(review_attributes(created_at: 7.days.ago, user: user))
    review3 = movie.reviews.create!(review_attributes(created_at: 1.day.ago, user: user))

    expect(movie.reviews).to eq([review3, review2, review1])
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

  it "has favorites" do
    movie = Movie.new(movie_attributes)
    user1 = User.new(user_attributes(email: "larry@example.com"))
    user2 = User.new(user_attributes(email: "moe@example.com"))

    favorite1 = movie.favorites.new(user: user1)
    favorite2 = movie.favorites.new(user: user2)

    expect(movie.favorites).to include(favorite1)
    expect(movie.favorites).to include(favorite2)
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

  it "has critics" do
    user1 = User.new(user_attributes(name: "User One",
      username: "user1", email: "user1@example.com"))
    user2 = User.new(user_attributes(name: "User Two",
      username: "user2", email: "user2@example.com"))

    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Superman"))
    review1 = movie1.reviews.new(review_attributes(user: user1))

    review2 = movie2.reviews.new(review_attributes(user: user2))

    expect(movie1.critics).to include(user1)
    expect(movie1.critics).not_to include(user2)
    expect(movie2.critics).to include(user2)
    expect(movie2.critics).not_to include(user1)
  end

  it "can exist in many genres" do
    movie = Movie.create!(movie_attributes)
    genre1 = Genre.create!(genre_attributes(name: "Action"))
    genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    genre3 = Genre.create!(genre_attributes(name: "Drama"))

    Characterization.create!(movie: movie, genre: genre1)
    Characterization.create!(movie: movie, genre: genre3)

    expect(movie.genres.count).to eq(2)
    expect(movie.genres).to include(genre1)
    expect(movie.genres).to include(genre3)
    expect(movie.genres).not_to include(genre2)
  end

  it "generates a slug when it's created" do
    movie = Movie.create!(movie_attributes(title: "X-Men: The Last Stand"))

    expect(movie.slug).to eq("x-men-the-last-stand")
  end

  it "requires a unique, case insensitive title" do
    movie1 = Movie.create!(movie_attributes)

    movie2 = Movie.new(title: movie1.title.upcase)
    movie2.valid? # populates errors
    expect(movie2.errors[:title].first).to eq("has already been taken")
  end

  it "requires a unique slug" do
    movie1 = Movie.create!(movie_attributes)

    movie2 = Movie.new(slug: movie1.slug)
    movie2.valid? # populates errors
    expect(movie2.errors[:slug].first).to eq("has already been taken")
  end

  it "overrides the default implementation of to_param" do
    movie = Movie.create!(movie_attributes)

    expect(movie.to_param).to eq(movie.slug)
    expect(movie.to_param).not_to eq(movie.id)
  end
end