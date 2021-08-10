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
      image_file_name: "ironman.jpg")

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
      image_file_name: "superman.jpg")

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
      image_file_name: "spider-man.jpg")
    visit movies_url

    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie2.title)
    expect(page).to have_text(movie3.title)

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

    expect(page).to have_xpath("//img[contains(@src, 'ironman.jpg')]")
    expect(page).to have_xpath("//img[contains(@src, 'superman.jpg')]")
    expect(page).to have_xpath("//img[contains(@src, 'spider-man.jpg')]")
  end

  it "does not show a movie that hasn't yet been released" do
    movie = Movie.create(movie_attributes(released_on: 1.month.from_now))

    visit movies_path

    expect(page).not_to have_text(movie.title)
  end
end