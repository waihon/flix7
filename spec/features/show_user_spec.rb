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
      user2 = User.create!(user_attributes(name: "Second User",
        username: "second", email: "second@example.com"))

      movie1 = Movie.create!(movie_attributes(title: "Avengers: Endgame"))
      review1_1 = movie1.reviews.create!(review_attributes(comment: "Loved!", stars: 5, user: @user))
      review1_2 = movie1.reviews.create!(review_attributes(comment: "Really cool!", stars: 4, user: user2))

      movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
      review2_1 = movie2.reviews.create!(review_attributes(comment: "Liked!", stars: 3, user: @user))
      review2_2 = movie2.reviews.create!(review_attributes(comment: "Boo!", stars: 2, user: user2))

      movie3 = Movie.create!(movie_attributes(title: "Black Panther"))
      review3_1 = movie3.reviews.create!(review_attributes(comment: "Cool!", stars: 4, user: @user))
      review3_2 = movie3.reviews.create!(review_attributes(comment: "Liked it!", stars: 3, user: user2))

      visit user_url(@user)

      expect(page).to have_text("Reviews")
      expect(page).to have_text(review1_1.comment)
      expect(page).to have_text(review2_1.comment)
      expect(page).to have_text(review3_1.comment)
      expect(page).not_to have_text(review1_2.comment)
      expect(page).not_to have_text(review2_2.comment)
      expect(page).not_to have_text(review3_2.comment)

      within find("#review-#{review1_1.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
        front_stars_style = page.find('div.front-stars')['style']
        expect(front_stars_style).to eq("width: 100.0%")
      end
      within find("#review-#{review2_1.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
        front_stars_style = page.find('div.front-stars')['style']
        expect(front_stars_style).to eq("width: 60.0%")
      end
      within find("#review-#{review3_1.id}") do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
        front_stars_style = page.find('div.front-stars')['style']
        expect(front_stars_style).to eq("width: 80.0%")
      end
    end

    it "doesn't show the Reviews section if the user hasn't written any reviews" do
      movie1 = Movie.create!(movie_attributes(title: "Avengers: Endgame"))
      movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
      movie3 = Movie.create!(movie_attributes(title: "Black Panther"))

      visit user_url(@user)

      expect(page).not_to have_text("Reviews")
    end

    it "show all the movies this user has favorited" do
      movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
      movie1.main_image.attach(assets_image("ironman.png"))
      movie2 = Movie.create!(movie_attributes(title: "Superman"))
      movie2.main_image.attach(assets_image("superman.png"))
      movie3 = Movie.create!(movie_attributes(title: "Black Panther"))
      movie3.main_image.attach(assets_image("black-panther.png"))

      movie1_favorite = movie1.favorites.create(user: @user)
      movie3_favorite = movie3.favorites.create(user: @user)

      visit user_url(@user)

      expect(page).to have_text("Favorite Movies")
      expect(page).to have_xpath("//a[contains(@href, '/movies/#{movie1.to_param}')]")
      expect(page).to have_xpath("//img[contains(@src, 'ironman.png')]")
      expect(page).to have_xpath("//a[contains(@href, '/movies/#{movie3.to_param}')]")
      expect(page).to have_xpath("//img[contains(@src, 'black-panther.png')]")
      expect(page).not_to have_xpath("//a[contains(@href, '/movies/#{movie2.to_param}')]")
      expect(page).not_to have_xpath("//img[contains(@src, 'superman.png')]")
    end
  end
end