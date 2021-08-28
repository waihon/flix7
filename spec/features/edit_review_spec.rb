require 'rails_helper'

describe "Editing a review" do
  it "updates the review and shows the review's updated details" do
    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(name: "Roger Ebert"))
    review2 = movie.reviews.create(review_attributes(name: "Gene Siskel"))
    review3 = movie.reviews.create(review_attributes(name: "Peter Travers"))

    visit movie_reviews_url(movie)
    expect(page).to have_text(review1.name)
    expect(page).to have_text(review2.name)
    expect(page).to have_text(review3.name)

    within find("#review-#{review2.id}") do
      click_link "Edit"
    end

    expect(current_path).to eq(edit_movie_review_path(movie, review2))
    expect(find_field('Name').value).to eq(review2.name)

    fill_in "Name", with: "Updated Reviewer Name"
    click_button "Update Review"

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).to have_text("Updated Reviewer Name")
    expect(page).to have_text("Review successfully updated!")
  end

  it "does not update the movie if it's invalid" do
    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(name: "Roger Ebert"))
    review2 = movie.reviews.create(review_attributes(name: "Gene Siskel"))
    review3 = movie.reviews.create(review_attributes(name: "Peter Travers"))

    visit edit_movie_review_url(movie, review3)

    fill_in "Name", with: " "

    click_button "Update Review"

    expect(page).to have_text("error")
  end
end