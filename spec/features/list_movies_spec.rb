require 'rails_helper'

describe "Viewing the list of movies" do
  it "shows the movies" do
    movie1 = Movie.create(title: "Iron Man",
      rating: "PG-13",
      total_gross: 318412101.00,
      description:
      %{
        When wealthy industrialist Tony Stark is forced to build an
        armored suit after a life-threatening incident, he ultimately
        decides to use its technology to fight against evil.
      }.squish,
      released_on: "2008-05-02",
      director: "Jon Favreau",
      duration: "126 min",
      image_file_name: "ironman.png")

    movie2 = Movie.create(title: "Superman",
      rating: "PG",
      total_gross: 134218018.00,
      description:
      %{
        An alien orphan is sent from his dying planet to Earth, where
        he grows up to become his adoptive home's first and greatest
        super-hero.
      }.squish,
      released_on: "1978-12-15",
      director: "Richard Donner",
      duration: "143 min",
      image_file_name: "superman.png")

    movie3 = Movie.create(title: "Spider-Man",
      rating: "PG-13",
      total_gross: 403706375.00,
      description:
      %{
        When bitten by a genetically modified spider, a nerdy, shy, and
        awkward high school student gains spider-like abilities that he
        eventually must use to fight evil as a superhero after tragedy
        befalls his family.
      }.squish,
      released_on: "2002-05-03",
      director: "Sam Raimi",
      duration: "121 min",
      image_file_name: "spiderman.png")

    movie1.reviews.create(review_attributes(stars: 2))
    movie1.reviews.create(review_attributes(stars: 3))
    movie1.reviews.create(review_attributes(stars: 4))
    movie1.reviews.create(review_attributes(stars: 4))
    movie1.reviews.create(review_attributes(stars: 5))

    movie3.reviews.create(review_attributes(stars: 4))
    movie3.reviews.create(review_attributes(stars: 4))
    movie3.reviews.create(review_attributes(stars: 5))

    visit movies_url

    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie2.title)
    expect(page).to have_text(movie3.title)

    # Partially filled-in stars
    within find("#movie-#{movie1.id}") do
      front_stars_style = page.find('div.front-stars')['style']
      expect(front_stars_style).to eq("width: 72.0%")
    end
    within find("#movie-#{movie2.id}") do
      front_stars_style = page.find('div.front-stars')['style']
      expect(front_stars_style).to eq("width: 0.0%")
    end
    within find("#movie-#{movie3.id}") do
      front_stars_style = page.find('div.front-stars')['style']
      expect(front_stars_style).to eq("width: 86.666666666666666%")
    end

    expect(page).to have_text(
      %{
        When wealthy industrialist Tony Stark is forced to build an
        armored suit after a life-threatening incident, he ultimately
        decides to use its...
      }.squish
    )
    expect(page).to have_text(
      %{
        An alien orphan is sent from his dying planet to Earth, where
        he grows up to become his adoptive home's first and greatest
        super-hero.
      }.squish
    )
    expect(page).to have_text(
      %{
        When bitten by a genetically modified spider, a nerdy, shy, and
        awkward high school student gains spider-like abilities that he
        eventually must use...
      }.squish
    )

    expect(page).to have_text("$318,412,101")
    expect(page).to have_text("Flop!")
    expect(page).to have_text("$403,706,375")

    expect(page).to have_xpath("//img[contains(@src, 'ironman.png')]")
    expect(page).to have_xpath("//img[contains(@src, 'superman.png')]")
    expect(page).to have_xpath("//img[contains(@src, 'spiderman.png')]")
  end

  it "does not show a movie that hasn't yet been released" do
    movie = Movie.create(movie_attributes(released_on: 1.month.from_now))

    visit movies_path

    expect(page).not_to have_text(movie.title)
  end

  it "doesn't show Add New Movie link when not signed in" do
    visit movies_url

    expect(current_path).to eq(movies_path)
    expect(page).not_to have_link("Add New Movie")
  end

  it "doesn't show Add New Movie link when not signed in as an admin user" do
    user = User.create!(user_attributes(admin: false))

    sign_in(user)

    visit movies_url

    expect(current_path).to eq(movies_path)
    expect(page).not_to have_link("Add New Movie")
  end

  it "shows Add New Movie link when signed in as an admin user" do
    admin = User.create!(user_attributes(admin: true))

    sign_in(admin)

    visit movies_url

    expect(current_path).to eq(movies_path)
    expect(page).to have_link("Add New Movie")
  end
end