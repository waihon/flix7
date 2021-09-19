require 'rails_helper'

describe "Viewing a user's profile page" do
  context "when signed in" do
    before do
      @user = User.create!(user_attributes)
      sign_in(@user)
    end

    it "shows the user's details" do
      visit user_url(@user)

      expect(page).to have_text(@user.name)
      expect(page).to have_text(@user.email)
      expect(page).to have_text(@user.created_at.strftime("%B %Y"))
      expect(page.find("#profile-image")["src"]).to have_content(@user.gravatar_id)

      expect(page).to have_link("Edit Account")
    end

    it "doesn't show Edit Account link if it's not the signed in user" do
      user2 = User.create!(user_attributes(email: "user2@example.com",
                                           username: "user2"))

      visit user_url(user2)

      expect(page).not_to have_link("Edit Account")
    end

    it "show all the reviews this user has written" do
      movie1 = Movie.create!(movie_attributes(title: "Avengers: Endgame"))
      review1 = movie1.reviews.create!(review_attributes(comment: "Loved!", user: @user))
      movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
      review2 = movie2.reviews.create!(review_attributes(comment: "Liked!", user: @user))
      movie3 = Movie.create!(movie_attributes(title: "Black Panther"))
      review3 = movie3.reviews.create!(review_attributes(comment: "Cool!", user: @user))

      visit user_url(@user)

      expect(page).to have_text("Reviews")
      expect(page).to have_text("Loved!")
      expect(page).to have_text("Liked!")
      expect(page).to have_text("Cool!")

      within find("#review-#{review1.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
      within find("#review-#{review2.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
      within find("#review-#{review3.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
    end

    it "doesn't show the Reviews section if the user hasn't written any reviews" do
      movie1 = Movie.create!(movie_attributes(title: "Avengers: Endgame"))
      movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
      movie3 = Movie.create!(movie_attributes(title: "Black Panther"))

      visit user_url(@user)

      expect(page).not_to have_text("Reviews")
    end
  end
end