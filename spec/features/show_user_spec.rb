require 'rails_helper'

describe "Viewing a user's profile page" do
  context "when signed in" do
    before do
      @user = User.create!(user_attributes)
      sign_in(@user)
    end
    
    it "shows the user's details" do
      visit user_url(@user)

      expect(page).to have_text(@user.name)
      expect(page).to have_text(@user.email)
      expect(page).to have_text(@user.created_at.strftime("%B %Y"))
      expect(page.find("#profile-image")["src"]).to have_content(@user.gravatar_id)

      expect(page).to have_link("Edit Account")
    end

    it "doesn't show Edit Account link if it's not the signed in user" do
      user2 = User.create!(user_attributes(email: "user2@example.com",
                                           username: "user2"))

      visit user_url(user2)

      expect(page).not_to have_link("Edit Account")
    end
  end
end