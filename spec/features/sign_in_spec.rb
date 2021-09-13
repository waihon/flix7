require 'rails_helper'

describe "Sigining in" do
  it "prompts for email and password" do
    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
    expect(page).to have_link("Sign up!")
  end
end