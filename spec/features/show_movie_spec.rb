require 'rails_helper'

describe "Viewing an individual movie" do
  it "shows the movie's details" do
    movie = Movie.create(movie_attributes(total_gross: 300_000_000))

    visit "http://example.com/movies/#{movie.id}"

    expect(page).to have_text(movie.title)
    expect(page).to have_text("2008")
    expect(page).to have_text(movie.description)
    expect(page).to have_text("$300,000,000")
    expect(page).to have_text("Jon Favreau")
    expect(page).to have_text("126 min")
    expect(page).to have_xpath("//img[contains(@src, 'ironman.jpg')]")
  end
end