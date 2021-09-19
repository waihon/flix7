require 'rails_helper'

describe "Editing a review" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)

    @movie = Movie.create(movie_attributes)
    @review1 = @movie.reviews.create(review_attributes(comment: "Loved", user: @user))
    @review2 = @movie.reviews.create(review_attributes(comment: "Liked", user: @user))
    @review3 = @movie.reviews.create(review_attributes(comment: "Boo!", user: @user))
  end

  context "from movie reviews page" do
    it "updates the review and shows the review's updated details" do
      visit movie_reviews_url(@movie)

      expect(page).to have_text(@review1.comment)
      expect(page).to have_text(@review2.comment)
      expect(page).to have_text(@review3.comment)

      within find("#review-#{@review2.id}") do
        click_link "Edit"
      end

      expect(current_path).to eq(edit_movie_review_path(@movie, @review2))
      expect(find_field('Comment').value).to eq(@review2.comment)

      fill_in "Comment", with: "Updated comment"
      click_button "Update Review"

      expect(current_path).to eq(movie_reviews_path(@movie))
      expect(page).to have_text("Updated comment")
      expect(page).to have_text("Review successfully updated!")
    end

    it "does not update the movie if it's invalid" do
      visit edit_movie_review_url(@movie, @review3)

      fill_in "Comment", with: " "

      click_button "Update Review"

      expect(page).to have_text("error")
    end
  end

  context "from user profile page" do
    it "updates the review and shows the review's updated details" do
      visit user_url(@user)

      expect(page).to have_text(@review1.comment)
      expect(page).to have_text(@review2.comment)
      expect(page).to have_text(@review3.comment)

      within find("#review-#{@review2.id}") do
        click_link "Edit"
      end

      expect(current_path).to eq(edit_movie_review_path(@movie, @review2))
      expect(find_field('Comment').value).to eq(@review2.comment)

      fill_in "Comment", with: "Updated comment"
      click_button "Update Review"

      expect(current_path).to eq(user_path(@user))
      expect(page).to have_text("Updated comment")
      expect(page).to have_text("Review successfully updated!")
    end
  end
end