require 'rails_helper'

describe "Deleting a user" do
  before do
    @user = User.create!(user_attributes(admin: false))
      sign_in(@user)
  end

  context "when not signed in as an admin user" do
    it "cannot see Delete Account link for own account" do
      visit user_path(@user)

      expect(page).not_to have_button "Delete Account"
    end

    it "cannot see Delete Account link for another acount" do
      another_user = User.create!(user_attributes(name: "Another User",
        email: "anotheruser@example.com",
        username: "anotheruser", admin: false))

      visit user_path(another_user)

      expect(page).not_to have_button "Delete Account"
    end
  end

  context "when signed in as an admin user" do
    before do
      @admin = User.create(user_attributes(name: "Administrator",
        email: "admin@example.com",
        username: "admin", admin: true))
      sign_in(@admin)
    end

    it "destroys another user and redirects to the home page" do
      visit user_path(@user)

      click_button "Delete Account"

      expect(current_path).to eq(root_path)
      expect(page).to have_text("Account successfully deleted!")

      visit users_path

      expect(page).not_to have_text(@user.name)
      expect(page).to have_button("Sign Out")
      expect(page).not_to have_link("Sign In")
    end

    it "destroys own account and auto signed out to the home page" do
      visit user_path(@admin)

      click_button "Delete Account"

      expect(current_path).to eq(root_path)
      expect(page).to have_text("Account successfully deleted!")

      expect(page).not_to have_text(@admin.name)
      expect(page).not_to have_link("Sign Out")
      expect(page).to have_link("Sign In")
      expect(page).to have_link("Sign Up")
    end
  end
end