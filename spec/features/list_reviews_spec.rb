require 'rails_helper'

describe "Viewing a list of reviews" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "shows the reviews for a specific movie" do
    movie1 = Movie.create(movie_attributes(title: "Iron Man"))
    review1 = movie1.reviews.create(review_attributes(comment: "Loved", stars: 5, user: @user))
    review2 = movie1.reviews.create(review_attributes(comment: "Liked", stars: 4, user: @user))

    movie2 = Movie.create(movie_attributes(title: "Superman"))
    review3 = movie2.reviews.create(review_attributes(comment: "Boo!", stars: 2, user: @user))

    visit movie_reviews_url(movie1)

    within find("#review-#{review1.id}") do
      expect(page).to have_text(review1.comment)
      expect(page).not_to have_text(review2.comment)
      expect(page).to have_text(@user.name)
      expect(page.find("#profile-image")["src"]).to have_content(@user.gravatar_id)
      front_stars_style = page.find('div.front-stars')['style']
      expect(front_stars_style).to eq("width: 100.0%")
    end

    within find("#review-#{review2.id}") do
      expect(page).to have_text(review2.comment)
      expect(page).not_to have_text(review1.comment)
      expect(page.find("#profile-image")["src"]).to have_content(@user.gravatar_id)
      front_stars_style = page.find('div.front-stars')['style']
      expect(front_stars_style).to eq("width: 80.0%")
    end

    expect(page).not_to have_text(review3.comment)

    expect(page).to have_link("Write Review")
  end

  it "shows Edit and Delete links for reviews written by the signed in user" do
    movie1 = Movie.create(movie_attributes(title: "Iron Man"))

    user2 = User.create!(user_attributes(name: "Second User", username: "second",
      email: "second@example.com"))
    user3 = User.create!(user_attributes(name: "Third User", username: "third",
      email: "third@example.com"))

    review1 = movie1.reviews.create!(review_attributes(comment: "Loved", user: @user))
    review2 = movie1.reviews.create!(review_attributes(comment: "Liked", user: user2))
    review3 = movie1.reviews.create!(review_attributes(comment: "Boo!", user: user3))

    expect(movie1.reviews.count).to eq(3)

    visit movie_reviews_url(movie1)

    within find("#review-#{review1.id}") do
      expect(page).to have_button("Edit")
      expect(page).to have_button("Delete")
    end
    within find("#review-#{review2.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end
    within find("#review-#{review3.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end

    sign_in(user2)

    visit movie_reviews_url(movie1)

    within find("#review-#{review1.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end
    within find("#review-#{review2.id}") do
      expect(page).to have_button("Edit")
      expect(page).to have_button("Delete")
    end
    within find("#review-#{review3.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end

    sign_in(user3)

    visit movie_reviews_url(movie1)

    within find("#review-#{review1.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end
    within find("#review-#{review2.id}") do
      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end
    within find("#review-#{review3.id}") do
      expect(page).to have_button("Edit")
      expect(page).to have_button("Delete")
    end
  end
end