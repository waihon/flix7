require 'rails_helper'

describe "Viewing a user's profile page" do
  it "shows the user's details" do
    user = User.create!(user_attributes)

    sign_in(user)

    visit user_url(user)

    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
    expect(page).to have_text(user.created_at.strftime("%B %Y"))
    expect(page.find("#profile-image")["src"]).to have_content(user.gravatar_id)

    expect(page).to have_link("Edit Account")
    expect(page).to have_link("Delete Account")
  end

  it "doesn't show account management links if not the same as signed in user" do
    user1 = User.create!(user_attributes(email: "user1@example.com",
                                         username: "user1"))
    user2 = User.create!(user_attributes(email: "user2@example.com",
                                         username: "user2"))

    sign_in(user1)

    visit user_url(user2)

    expect(page).not_to have_link("Edit Account")
    expect(page).not_to have_link("Delete Account")
  end
end