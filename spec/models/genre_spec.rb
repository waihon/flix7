require 'rails_helper'

describe "A genre" do
  it "requires a name" do
    genre = Genre.new(name: "")

    genre.valid?

    expect(genre.errors[:name].any?).to eq(true)
  end

  it "requires a unique, case insensitive name" do
    genre1 = Genre.create(name: "Genre 1")

    genre2 = Genre.new(name: genre1.name.upcase)
    genre2.valid?
    expect(genre2.errors[:name].first).to eq("has already been taken")
  end
end
