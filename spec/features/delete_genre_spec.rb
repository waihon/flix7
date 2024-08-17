require 'rails_helper'

describe "Deleting a genre" do
  before do
    @admin = User.create!(user_attributes(admin: true))
    sign_in(@admin)

    @genre1 = Genre.create!(genre_attributes(name: "Action"))
    @genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    @genre3 = Genre.create!(genre_attributes(name: "Thriller"))
  end

  it "destroys the genre and shows the genres listing without the deleted genre" do
    visit genre_path(@genre2)

    click_button "Delete"

    expect(current_path).to eq(genres_path)
    expect(page).to have_link(@genre1.name)
    expect(page).not_to have_link(@genre2.name)
    expect(page).to have_link(@genre3.name)
    expect(page).to have_text("Genre successfully deleted!")
  end
end