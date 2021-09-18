require 'rails_helper'

describe "Deleting a review" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "destroys the review and shows the review listing without the deleted review" do
    movie = Movie.create(movie_attributes)
    review1 = movie.reviews.create(review_attributes(comment: "Loved", user: @user))
    review2 = movie.reviews.create(review_attributes(comment: "Liked", user: @user))
    review3 = movie.reviews.create(review_attributes(comment: "Boo!", user: @user))

    visit movie_reviews_url(movie)

    expect(page).to have_text(review1.comment)
    expect(page).to have_text(review2.comment)
    expect(page).to have_text(review3.comment)
    within find("#review-#{review2.id}") do
      click_link "Delete"
    end

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).to have_text(review1.comment)
    expect(page).not_to have_text(review2.comment)
    expect(page).to have_text(review3.comment)
    expect(page).to have_text("Review successfully deleted!")
  end
end