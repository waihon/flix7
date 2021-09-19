require 'rails_helper'

describe "Viewing an individual movie" do
  before do
    @user = User.create(user_attributes(admin: false))
  end

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
    front_stars_style = page.find('div.front-stars')['style']
    expect(front_stars_style).to eq("width: 0.0%")
  end

  it "shows the average stars in partially-filled stars" do
    movie = Movie.create(movie_attributes(total_gross: 300_000_000))
    review1 = movie.reviews.create(review_attributes(stars: 5, user: @user))
    review2 = movie.reviews.create(review_attributes(stars: 4, user: @user))
    review3 = movie.reviews.create(review_attributes(stars: 3, user: @user))
    review4 = movie.reviews.create(review_attributes(stars: 4, user: @user))
    review5 = movie.reviews.create(review_attributes(stars: 3, user: @user))
    review6 = movie.reviews.create(review_attributes(stars: 3, user: @user))
    review7 = movie.reviews.create(review_attributes(stars: 4, user: @user))

    visit movie_url(movie)

    expect(page).to have_link("7 Reviews")
    front_stars_style = page.find('div.front-stars')['style']
    expect(front_stars_style).to eq("width: 74.285714285714286%")
  end

  context "when not signed in" do
    it "doesn't show Edit and Delete links" do
      movie = Movie.create!(movie_attributes)

      visit movie_url(movie)

      expect(current_path).to eq(movie_path(movie))

      expect(page).not_to have_link("Edit")
      expect(page).not_to have_link("Delete")
    end

    it "doesn't show Post Review form" do
      movie = Movie.create(movie_attributes)

      visit movie_url(movie)

      expect(page).not_to have_text("Review:")
      expect(page).not_to have_selector("input[type=submit][value='Post Review']")
    end
  end

  context "when signed in but not as an admin user" do
    before do
      sign_in(@user)
    end

    it "doesn't show Edit and Delete links" do
      movie = Movie.create!(movie_attributes)

      visit movie_url(movie)

      expect(current_path).to eq(movie_path(movie))

      expect(page).not_to have_link("Edit")
      expect(page).not_to have_link("Delete")
    end

    it "show Post Review form" do
      movie = Movie.create!(movie_attributes)

      visit movie_url(movie)

      expect(current_path).to eq(movie_path(movie))

      expect(page).to have_text("Review:")
      expect(page).to have_selector("input[type=submit][value='Post Review']")
    end
  end

  context "when signed in as an admin user" do
    before do
      @admin = User.create!(user_attributes(name: "Admin", username: "admin",
        email: "admin@example.com", admin: true))
      sign_in(@admin)
    end

    it "show Edit and Delete links when signed in as an admin user" do
      movie = Movie.create!(movie_attributes)

      visit movie_url(movie)

      expect(current_path).to eq(movie_path(movie))

      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end
  end
end