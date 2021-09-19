require 'rails_helper'

describe "A user" do
  it "requires a name" do
    user = User.new(name: "")

    user.valid? # populates errors

    expect(user.errors[:name].any?).to eq(true)
  end

  it "requires an email" do
    user = User.new(email: "")
    
    user.valid?

    expect(user.errors[:email].any?).to eq(true)
  end

  it "accepts properly formatted email address" do
    emails = %w[user@example.com first.last@example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(false)
    end
  end

  it "rejects improperly formatted email address" do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(true) 
    end
  end

  it "rejects email address without FQDN" do
    emails = %w[user@example first.last@example]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(true)
    end
  end

  it "requires a unique, case insensitive email address" do
    user1 = User.create!(user_attributes)

    user2 = User.new(email: user1.email.upcase)
    user2.valid?
    expect(user2.errors[:email].first).to eq("has already been taken")
  end

  it "is valid with example attributes" do
    user = User.new(user_attributes)

    expect(user.valid?).to eq(true)
  end

  it "requires a password" do
    user = User.new(password: "")

    user.valid?

    expect(user.errors[:password].any?).to eq(true)
  end

  it "requires a password confirmation when a password is present" do
    user = User.new(password: "secretpassword", password_confirmation: "nomatch")

    user.valid?

    expect(user.errors[:password_confirmation].first).to eq("doesn't match Password")
  end

  it "requires a password and matching password confirmation when creating" do
    user = User.create!(user_attributes(password: "secretpassword", password_confirmation: "secretpassword"))

    expect(user.valid?).to eq(true)
  end
  
  it "does not require a password when updating" do
    user = User.create!(user_attributes)

    user.password = ""

    expect(user.valid?).to eq(true)
  end

  it "automatically encrypts the password into the password_digest attribute" do
    user = User.new(password: "secretpassword")

    expect(user.password_digest.present?).to eq(true)
    
  end

  it "allows password with a minimum length of 10" do
    passwords = ["a" * 10, "b" * 15, "c" * 20]
    passwords.each do |password|
      user = User.new(password: password)
      user.valid?
      expect(user.errors[:password].any?).to eq(false)
    end
  end

  it "rejects password with a length less than 10" do
    passwords = ["a" * 1, "b" * 5, "c" * 9]
    passwords.each do |password|
      user = User.new(password: password)
      user.valid?
      expect(user.errors[:password].first).to match(/is too short/)
    end
  end

  it "has a gravatar ID" do
    user = User.new(user_attributes)

    expect(user.gravatar_id).to eq("b58996c504c5638798eb6b511e6f49af")
  end

  it "requires a username" do
    user = User.new(username: "")

    user.valid?

    expect(user.errors[:username].any?).to eq(true)
  end

  it "accepts a username with letters and numbers" do
    usernames = %w[username 123456 user168 168user user168name 16user8]
    usernames.each do |username|
      user = User.new(username: username)
      user.valid?
      expect(user.errors[:username].any?).to eq(false)
    end
  end

  it "rejects a username with any non-word character" do
    usernames = ["@~!", "#$%", "^&*", "()-", "username+", "_username", "user.name"]
    usernames.each do |username|
      user = User.new(username: username)
      user.valid?
      expect(user.errors[:username].any?).to eq(true)
    end
  end

  it "rejects username with spaces" do
    usernames = ["user name", " username", "username ", "user   name"]
    usernames.each do |username|
      user = User.new(username: username)
      user.valid?
      expect(user.errors[:username].any?).to eq(true)
    end
  end

  it "requires a unique, case insensitive username" do
    user1 = User.create!(user_attributes)

    user2 = User.new(username: user1.username.upcase)
    user2.valid?
    expect(user2.errors[:username].first).to eq("has already been taken")
  end

  it "has reviews" do
    user = User.new(user_attributes)

    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Superman"))

    review1 = movie1.reviews.new(stars: 5, comment: "Two thumbs up!")
    review1.user = user
    review1.save!

    review2 = movie2.reviews.new(stars: 3, comment: "Cool!")
    review2.user = user
    review2.save!

    expect(user.reviews).to include(review1)
    expect(user.reviews).to include(review2)
  end

  it "has favorite movies" do
    user = User.new(user_attributes)
    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Superman"))

    user.favorites.new(movie: movie1)
    user.favorites.new(movie: movie2)

    expect(user.favorite_movies).to include(movie1)
    expect(user.favorite_movies).to include(movie2)
  end
end