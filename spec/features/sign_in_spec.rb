require 'rails_helper'

describe "Signing in" do
  it "prompts for email and password" do
    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
    expect(page).to have_link("Sign up!")
  end

  it "signs in the user if the email/password combination is valid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    fill_in "Email or username", with: user.email
    fill_in "Password", with: user.password

    click_button "Sign In"

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")

    expect(page).to have_link(user.name)
    expect(page).to have_link("Account Settings")
    expect(page).to have_link("Sign Out")

    expect(page).not_to have_link("Sign In")
    expect(page).not_to have_link("Sign Up")

  end

  it "does not sign in the user if the email/password combination is invalid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    fill_in "Email or username", with: user.email
    fill_in "Password", with: "no match"

    click_button "Sign In"

    expect(page).to have_text("Invalid email/password combination!")
    expect(current_path).not_to eq(user_path(user))

    expect(page).to have_link("Sign In")
    expect(page).to have_link("Sign Up")

    expect(page).not_to have_link(user.name)
    expect(page).not_to have_link("Account Settings")
    expect(page).not_to have_link("Sign Out")
  end

  it "signs in the user if the username/password combination is valid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    fill_in "Email or username", with: user.username
    fill_in "Password", with: user.password

    click_button "Sign In"

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")

    expect(page).to have_link(user.name)
    expect(page).to have_link("Account Settings")
    expect(page).to have_link("Sign Out")

    expect(page).not_to have_link("Sign In")
    expect(page).not_to have_link("Sign Up")
  end

  it "does not sign in the user if the username/password combination is invalid" do
    user = User.create!(user_attributes)

    visit root_url

    click_link "Sign In"

    expect(current_path).to eq(signin_path)

    fill_in "Email or username", with: user.username
    fill_in "Password", with: "no match"

    click_button "Sign In"

    expect(page).to have_text("Invalid email/password combination!")
    expect(current_path).not_to eq(user_path(user))

    expect(page).to have_link("Sign In")
    expect(page).to have_link("Sign Up")

    expect(page).not_to have_link(user.name)
    expect(page).not_to have_link("Account Settings")
    expect(page).not_to have_link("Sign Out")
  end
end