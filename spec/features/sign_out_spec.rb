require 'rails_helper'

describe "Signing out" do
  it "removes the user id from the session" do
    user = User.create!(user_attributes)

    sign_in(user)

    click_button "Sign Out"

    expect(page).to have_text("signed out")
    expect(page).not_to have_button("Sign Out")
    expect(page).to have_link("Sign In")
  end
end