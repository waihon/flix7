require 'rails_helper'

describe "Viewing the list of genres" do
  before do
    @genre1 = Genre.create!(genre_attributes(name: "Action", image_file_name: "action.png"))
    @genre2 = Genre.create!(genre_attributes(name: "Adventure", image_file_name: "adventure.png"))
    @genre3 = Genre.create!(genre_attributes(name: "Sci-Fi", image_file_name: "sci-fi.png"))

    @movie1 = Movie.create!(movie_attributes(title: "Avengers: Endgame"))
    @movie2 = Movie.create!(movie_attributes(title: "Captain Marvel"))
    @movie3 = Movie.create!(movie_attributes(title: "Avengers: Infinity War"))
    @movie4 = Movie.create!(movie_attributes(title: "Black Panther"))
    @movie5 = Movie.create!(movie_attributes(title: "Wonder Woman"))
    @movie6 = Movie.create!(movie_attributes(title: "Fantastic Four"))
    @movie7 = Movie.create!(movie_attributes(title: "Green Lantern"))
    @movie8 = Movie.create!(movie_attributes(title: "Iron Man"))
    @movie9 = Movie.create!(movie_attributes(title: "Catwoman"))

    @movie1.genres << @genre1

    @movie2.genres << @genre2
    @movie3.genres << @genre2
    @movie4.genres << @genre2

    @movie5.genres << @genre3
    @movie6.genres << @genre3
    @movie7.genres << @genre3
    @movie8.genres << @genre3
    @movie9.genres << @genre3
  end

  it "shows the genres with number of associated movies" do
    visit genres_url

    expect(current_path).to eq(genres_path)

    within find("#genre-#{@genre1.id}") do
      expect(page).to have_xpath("//img[contains(@src, 'action.png')]")
      expect(page).to have_link(@genre1.name)
      expect(page).to have_text("1 Movie")
    end

    within find("#genre-#{@genre2.id}") do
      expect(page).to have_xpath("//img[contains(@src, 'adventure.png')]")
      expect(page).to have_link(@genre2.name)
      expect(page).to have_text("3 Movies")
    end

    within find("#genre-#{@genre3.id}") do
      expect(page).to have_xpath("//img[contains(@src, 'sci-fi.png')]")
      expect(page).to have_link(@genre3.name)
      expect(page).to have_text("5 Movies")
    end
  end  

  context "when not signed in" do
    it "doesn't show Add New Genre link" do
      visit genres_url
      
      expect(current_path).to eq(genres_path)

      expect(page).not_to have_link("Add New Genre")
    end
  end

  context "when signed in but not as an admin user" do
    before do
      @user = User.create!(user_attributes(admin: false))
      sign_in(@user)
    end

    it "doesn't show Add New Genre link" do
      visit genres_url
      
      expect(current_path).to eq(genres_path)

      expect(page).not_to have_link("Add New Genre")
    end
  end

  context "when signed in as an admin user" do
    before do
      @admin = User.create!(user_attributes(admin: true))
      sign_in(@admin)      
    end

    it "shows Add New Genre link" do
      visit genres_url
      
      expect(current_path).to eq(genres_path)

      expect(page).to have_link("Add New Genre")
    end
  end
end