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
end