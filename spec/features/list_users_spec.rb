require 'rails_helper'

describe "Viewing the list of users" do
  it "shows the users" do
    CREATED_AGO = "created less than a minute ago"

    user1 = User.create!(user_attributes(name: "Larry", email: "larry@example.com", username: "larry"))
    user2 = User.create!(user_attributes(name: "Moe", email: "moe@example.com", username: "moe"))
    user3 = User.create!(user_attributes(name: "Curly", email: "curly@example.com", username: "curly"))

    visit users_url

    expect(page).to have_text("3 Users")
    within find("#user-#{user1.id}") do
      expect(page).to have_link(user1.name)
      expect(page).to have_text(CREATED_AGO)
    end
    within find("#user-#{user2.id}") do
      expect(page).to have_link(user2.name)
      expect(page).to have_text(CREATED_AGO)
    end
    within find("#user-#{user3.id}") do
      expect(page).to have_link(user3.name)
      expect(page).to have_text(CREATED_AGO)
    end
  end
end