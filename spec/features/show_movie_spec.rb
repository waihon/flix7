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
    expect(page).to have_xpath("//img[contains(@src, 'ironman.png')]")
    expect(page).to have_link("0 Reviews")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Delete")
    expect(page).to have_selector("input[type=submit][value='Post Review']")
    expect(page).to have_text("No reviews")
  end

  it "shows the average number of review stars" do
    movie = Movie.create(movie_attributes(total_gross: 300_000_000))
    review1 = movie.reviews.create(review_attributes(stars: 1))
    review2 = movie.reviews.create(review_attributes(stars: 2))
    review3 = movie.reviews.create(review_attributes(stars: 3))
    review4 = movie.reviews.create(review_attributes(stars: 3))
    review5 = movie.reviews.create(review_attributes(stars: 3))
    review6 = movie.reviews.create(review_attributes(stars: 4))
    review7 = movie.reviews.create(review_attributes(stars: 4))
    review8 = movie.reviews.create(review_attributes(stars: 5))

    visit "http://example.com/movies/#{movie.id}"

    expect(page).to have_link("8 Reviews")
    expect(page).to have_text("3.1 stars")
  end
end