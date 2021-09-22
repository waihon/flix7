require 'rails_helper'

describe "A characterization" do
  it "belongs to a movie" do
    movie = Movie.create!(movie_attributes)

    characterization = movie.characterizations.new

    expect(characterization.movie).to eq(movie)
  end

  it "belongs to a genre" do
    genre = Genre.create(genre_attributes)

    characterization = genre.characterizations.new

    expect(characterization.genre).to eq(genre)
  end

  it "requires a movie" do
    characterization = Characterization.new(movie: nil)

    characterization.valid?

    expect(characterization.errors[:movie].any?).to eq(true)
  end

  it "requires a genre" do
    characterization = Characterization.new(genre: nil)

    characterization.valid?

    expect(characterization.errors[:genre].any?).to eq(true)
  end
end
