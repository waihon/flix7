require 'rails_helper'

describe "Viewing the list of users" do
  it "shows non-admin users" do
    CREATED_AGO = "created less than a minute ago"

    user1 = User.create!(user_attributes(name: "Larry", email: "larry@example.com",
      username: "larry", admin: false))
    user2 = User.create!(user_attributes(name: "Moe", email: "moe@example.com",
      username: "moe", admin: false))
    user3 = User.create!(user_attributes(name: "Curly", email: "curly@example.com",
      username: "curly", admin: false))
    user4 = User.create!(user_attributes(name: "Admin", email: "admin@example.com",
      username: "admin", admin: true))

    sign_in(user1)

    visit users_url

    expect(page).to have_text("3 Users")

    expect(page).to have_css("#user-#{user1.id}")
    within find("#user-#{user1.id}") do
      expect(page).to have_link(user1.name)
      expect(page).to have_text(CREATED_AGO)
    end

    expect(page).to have_css("#user-#{user1.id}")
    within find("#user-#{user2.id}") do
      expect(page).to have_link(user2.name)
      expect(page).to have_text(CREATED_AGO)
    end

    expect(page).to have_css("#user-#{user3.id}")
    within find("#user-#{user3.id}") do
      expect(page).to have_link(user3.name)
      expect(page).to have_text(CREATED_AGO)
    end

    expect(page).not_to have_css("#user-#{user4.id}")
  end
end