require 'rails_helper'

describe "Editing a movie" do
  before do
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)

    @genre1 = Genre.create!(genre_attributes(name: "Action"))
    @genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    @genre3 = Genre.create!(genre_attributes(name: "Drama"))
  end

  it "updates the movie and shows the movie's updated details" do
    movie = Movie.create(movie_attributes)
    movie.genres << @genre2

    visit movie_url(movie)
    click_button 'Edit'

    expect(current_path).to eq(edit_movie_path(movie))
    expect(find_field('Title').value).to eq(movie.title)

    fill_in "Title", with: "Updated Movie Title"
    check(@genre1.name)
    uncheck(@genre2.name)
    check(@genre3.name)
    click_button "Update Movie"

    # Title has been updated and so has slug
    movie.reload

    expect(current_path).to eq(movie_path(movie))
    expect(page).to have_text("Updated Movie Title")
    expect(page).to have_text("Movie successfully updated!")

    expect(page).to have_text(@genre1.name)
    expect(page).to have_text(@genre3.name)
    expect(page).not_to have_text(@genre2.name)
  end

  it "does not update the movie if it's invalid" do
    movie = Movie.create(movie_attributes)

    visit edit_movie_url(movie)

    fill_in "Title", with: " "

    click_button "Update Movie"

    expect(page).to have_text("error")
  end
end