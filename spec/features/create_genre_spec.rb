require 'rails_helper'

describe "Creating a new genre" do
  before do
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)

    @genre1 = Genre.create!(genre_attributes(name: "Action"))
    @genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    @genre3 = Genre.create!(genre_attributes(name: "Drama"))
  end

  it "saves the genre and shows it in genres page" do
    visit genres_url
    click_link "Add New Genre"

    expect(current_path).to eq(new_genre_path)

    fill_in "Name", with: "Thriller"
    fill_in "Image file name", with: "thriller.png"

    click_button "Create Genre"

    expect(current_path).to eq(genres_path)
    expect(page).to have_text("Genre successfully created!")

    genre = Genre.last
    within find("#genre-#{genre.id}") do
      expect(page).to have_xpath("//img[contains(@src, 'thriller.png')]")
      expect(page).to have_link(genre.name)
      expect(page).to have_text("0 Movies")
    end
  end

  it "does not save the genre if it's invalid" do
    visit new_genre_url

    expect {
      click_button "Create Genre"
    }.not_to change(Genre, :count)

    # Click "Create Genre" would post to /genres
    expect(current_path).to eq(genres_path)
    expect(page).to have_text("error")
  end
end