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
    front_stars_style = page.find('div.front-stars')['style']
    expect(front_stars_style).to eq("width: 0.0%")
  end

  it "shows the average stars in partially-filled stars" do
    movie = Movie.create(movie_attributes(total_gross: 300_000_000))
    review1 = movie.reviews.create(review_attributes(stars: 5))
    review2 = movie.reviews.create(review_attributes(stars: 4))
    review3 = movie.reviews.create(review_attributes(stars: 3))
    review4 = movie.reviews.create(review_attributes(stars: 4))
    review5 = movie.reviews.create(review_attributes(stars: 3))
    review6 = movie.reviews.create(review_attributes(stars: 3))
    review7 = movie.reviews.create(review_attributes(stars: 4))

    visit "http://example.com/movies/#{movie.id}"

    expect(page).to have_link("7 Reviews")
    front_stars_style = page.find('div.front-stars')['style']
    expect(front_stars_style).to eq("width: 74.285714285714286%")
  end
end