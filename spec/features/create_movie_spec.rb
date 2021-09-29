require 'rails_helper'

describe "Creating a new movie" do
  before do
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)

    @genre1 = Genre.create!(genre_attributes(name: "Action"))
    @genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    @genre3 = Genre.create!(genre_attributes(name: "Drama"))
  end

  it "saves the movie and shows the new movie's details" do
    visit movies_url
    click_link "Add New Movie"

    expect(current_path).to eq(new_movie_path)

    fill_in "Title", with: "New Movie Title"
    fill_in "Description", with: "Superheroes saving the world from villains"
    select "PG-13", :from => "movie_rating"
    fill_in "Total gross", with: "75000000"
    select (Time.now.year - 1).to_s, :from => "movie_released_on_1i"
    fill_in "Director", with: "The ever-creative director"
    fill_in "Duration", with: "123 min"
    attach_file "Main image", assets_image_path
    # If you're taking advantage of the HTML 5 date field in Chrome,
    # you'll need to use 'fill_in' rather than 'select'.
    # fill_in "Released on", with: (Time.now.year - 1).to_s

    check(@genre1.name)
    check(@genre2.name)

    click_button "Create Movie"

    expect(current_path).to eq(movie_path(Movie.last))
    expect(page).to have_text("New Movie Title")
    expect(page).to have_text("Movie successfully created!")

    expect(page).to have_text(@genre1.name)
    expect(page).to have_text(@genre2.name)
    expect(page).not_to have_text(@genre3.name)
  end

  it "does not save the movie if it's invalid" do
    visit new_movie_url

    expect {
      click_button "Create Movie"
    }.not_to change(Movie, :count)

    # Clicking "Create Movie" would post to /movies
    expect(current_path).to eq(movies_path)
    expect(page).to have_text("error")
  end
end