require 'rails_helper'

describe "Viewing an individual genre" do
  before do
    @genre1 = Genre.create!(genre_attributes(name: "Action", image_file_name: "action.png"))
    @genre2 = Genre.create!(genre_attributes(name: "Adventure", image_file_name: "adventure.png"))

    @movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
    @movie1.main_image.attach(assets_image("ironman.png"))
    @movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
    @movie2.main_image.attach(assets_image("captain-marvel.png"))
    @movie3 = Movie.create!(movie_attributes(title: "Black Panther"))
    @movie3.main_image.attach(assets_image("black-panther.png"))
    @movie4 = Movie.create!(movie_attributes(title: "Superman"))
    @movie4.main_image.attach(assets_image("superman.png"))


    @movie1.genres << @genre1
    @movie3.genres << @genre1
    @movie2.genres << @genre2
    @movie4.genres << @genre2
  end

  it "shows movies associated with the genre" do
    visit genre_url(@genre1)
    expect(current_path).to eq(genre_path(@genre1))
    expect(page).to have_text(@genre1.name)
    expect(page).to have_xpath("//img[contains(@src, 'action.png')]")
    expect(page).to have_link(@movie1.title)
    expect(page).to have_link(@movie3.title)
    expect(page).not_to have_link(@movie2.title)
    expect(page).not_to have_link(@movie4.title)

    visit genre_url(@genre2)
    expect(current_path).to eq(genre_path(@genre2))
    expect(page).to have_xpath("//img[contains(@src, 'adventure.png')]")
    expect(page).to have_text(@genre2.name)
    expect(page).to have_link(@movie2.title)
    expect(page).to have_link(@movie4.title)
    expect(page).not_to have_link(@movie1.title)
    expect(page).not_to have_link(@movie3.title)
  end
end