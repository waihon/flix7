require 'rails_helper'

describe "Deleting a review" do
  it "destroys the review and shows the review listing without the deleted review" do
    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(name: "Larry"))
    review2 = movie.reviews.create(review_attributes(name: "Moe"))
    review3 = movie.reviews.create(review_attributes(name: "Lucy"))

    visit movie_reviews_url(movie)

    expect(page).to have_text("Larry")
    expect(page).to have_text("Moe")
    expect(page).to have_text("Lucy")
    within find("#review-#{review2.id}") do
      click_link "Delete"
    end

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).to have_text("Larry")
    expect(page).not_to have_text("Moe")
    expect(page).to have_text("Lucy")
    expect(page).to have_text("Review successfully deleted!")
  end
end