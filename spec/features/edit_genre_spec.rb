require 'rails_helper'

describe "Editing a genre" do
  before do
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)

    @genre1 = Genre.create!(genre_attributes(name: "Action"))
    @genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    @genre3 = Genre.create!(genre_attributes(name: "Drama"))
  end

  it "updates the genre and shows the genre's updated details" do
    visit genres_url
    expect(current_path).to eq(genres_path)

    click_link(@genre2.name)
    expect(current_path).to eq(genre_path(@genre2))
    expect(page).to have_text(@genre2.name)

    click_button("Edit")
    expect(current_path).to eq(edit_genre_path(@genre2))
    expect(find_field('Name').value).to eq(@genre2.name)

    fill_in "Name", with: "Updated Genre Name"
    click_button "Update Genre"

    # Name has been updated and so has slug
    @genre2.reload

    expect(current_path).to eq(genre_path(@genre2))
    expect(page).to have_text("Genre successfully updated!")
    expect(page).to have_text("Updated Genre Name")
  end

  it "does not update the genre if it's invalid" do
    visit edit_genre_url(@genre3)

    fill_in "Name", with: " "

    click_button "Update Genre"

    expect(page).to have_text("error")
  end
end