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
end