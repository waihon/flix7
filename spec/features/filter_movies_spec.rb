require 'rails_helper'

describe "Filtering movies" do
  it "shows hit movies" do
    movie = Movie.create!(movie_attributes(released_on: 1.day.ago, total_gross: 300_000_000))

    visit movies_url

    click_link "Hits"

    expect(current_path).to eq("/movies/hits")

    expect(page).to have_text(movie.title)
  end

  it "shows flop movies" do
    movie = Movie.create!(movie_attributes(released_on: 1.day.ago, total_gross: 224_999_999))

    visit movies_url

    click_link "Flops"

    expect(current_path).to eq("/movies/flops")

    expect(page).to have_text(movie.title)
  end

  it "shows upcoming movies" do
    movie = Movie.create!(movie_attributes(released_on: 1.day.from_now))

    visit movies_url

    click_link "Upcoming"

    expect(current_path).to eq("/movies/upcoming")

    expect(page).to have_text(movie.title)
  end

  it "show recent movies" do
    movie = Movie.create!(movie_attributes(released_on: 1.day.ago))

    visit movies_url

    click_link "Recent"

    expect(current_path).to eq("/movies/recent")

    expect(page).to have_text(movie.title)
  end  
end