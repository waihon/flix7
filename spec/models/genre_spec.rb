require 'rails_helper'

describe "A genre" do
  it "requires a name" do
    genre = Genre.new(name: "")

    genre.valid?

    expect(genre.errors[:name].any?).to eq(true)
  end

  it "requires a unique, case insensitive name" do
    genre1 = Genre.create(name: "Genre 1")

    genre2 = Genre.new(name: genre1.name.upcase)
    genre2.valid?
    expect(genre2.errors[:name].first).to eq("has already been taken")
  end

  it "can contain many movies" do
    movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
    movie3 = Movie.create!(movie_attributes(title: "Black Panther"))

    genre = Genre.create!(genre_attributes)

    Characterization.create!(movie: movie1, genre: genre)
    Characterization.create!(movie: movie3, genre: genre)

    expect(genre.movies.count).to eq(2)
    expect(genre.movies).to include(movie1)
    expect(genre.movies).to include(movie3)
    expect(genre.movies).not_to include(movie2)
  end

  it "accepts properly formatted image file names" do
    file_names = %w[e.png genre.png genre.jpg]
    file_names.each do |file_name|
      genre = Genre.new(image_file_name: file_name)
      genre.valid?
      expect(genre.errors[:image_file_name].any?).to eq(false)
    end
  end

  it "rejects improperly formatted image file names" do
    file_names = %w[genre .jpg .png genre.gif genre.pdf genre.doc]
    file_names.each do |file_name|
      genre = Genre.new(image_file_name: file_name)
      genre.valid?
      expect(genre.errors[:image_file_name].any?).to eq(true)
    end
  end
end
