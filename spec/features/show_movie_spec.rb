require 'rails_helper'

describe "Viewing an individual movie" do
  before do
    @user = User.create(user_attributes(admin: false))
  end

  it "shows the movie's details" do
    movie = Movie.create(movie_attributes(total_gross: 300_000_000))
    movie.main_image.attach(assets_image("ironman.png"))

    visit movie_url(movie)

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

    expect(page).not_to have_text("Review:")
    expect(page).not_to have_text("Fans")
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

  it "shows the fans" do
    movie1 = Movie.create(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create(movie_attributes(title: "Superman"))

    fan1 = User.create!(user_attributes(name: "Fan One",
      username: "fan1", email: "fan1@example.com"))
    fan2 = User.create!(user_attributes(name: "Fan Two",
      username: "fan2", email: "fan2@example.com"))
    fan3 = User.create!(user_attributes(name: "Fan Three",
      username: "fan3", email: "fan3@example.com"))

    movie1.favorites.create(user: fan1)
    movie1.favorites.create(user: fan3)
    movie2.favorites.create(user: fan2)

    visit movie_url(movie1)
    expect(page).to have_text("Fans")
    expect(page).to have_link(fan1.name)
    expect(page).to have_link(fan3.name)
    expect(page).not_to have_link(fan2.name)
  end

  it "shows the genres" do
    movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create!(movie_attributes(title: "Superman"))

    genre1 = Genre.create!(genre_attributes(name: "Action"))
    genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    genre3 = Genre.create!(genre_attributes(name: "Drama"))

    movie1.genres << genre1
    movie1.genres << genre3
    movie2.genres << genre2

    visit movie_url(movie1)
    expect(page).to have_text("Genres")
    expect(page).to have_link(genre1.name)
    expect(page).to have_link(genre3.name)
    expect(page).not_to have_link(genre2.name)
  end

  it "has an SEO-friendly URL" do
    movie = Movie.create!(movie_attributes(title: "X-Men: The Last Stand"))

    visit movie_url(movie)

    expect(current_path).to eq("/movies/x-men-the-last-stand")
  end

  context "when not signed in" do
    it "doesn't show Edit and Delete links" do
      movie = Movie.create!(movie_attributes)

      visit movie_url(movie)

      expect(current_path).to eq(movie_path(movie))

      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
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

      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
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

      expect(page).to have_button("Edit")
      expect(page).to have_button("Delete")
    end
  end
end