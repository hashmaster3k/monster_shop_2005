# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
#
# my name
# my street address
# my city
# my state
# my zip code
# my email address
# my preferred password
# a confirmation field for my password
# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in

require 'rails_helper'

RSpec.describe "User registration" do
  it 'as a visitor I see a register link in the nav bar' do
    visit '/merchants'

    within ".topnav" do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: 'name'
    fill_in :address, with: 'address'
    fill_in :city, with: 'city'
    fill_in :state, with: 'state'
    fill_in :zip, with: 'zip'
    fill_in :email, with: 'email'
    fill_in :password, with: 'password'
    fill_in :confirm_password, with: 'password'

    click_button "Create New User"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("You are now registered and logged in")
  end

  it 'cannot create user with missing fields' do
    visit '/merchants'

    within ".topnav" do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: 'name'
    fill_in :address, with: 'address'
    fill_in :city, with: 'city'
    fill_in :state, with: 'state'
    fill_in :zip, with: 'zip'
    fill_in :email, with: ''
    fill_in :password, with: 'password'
    fill_in :confirm_password, with: 'password'

    click_button "Create New User"

    expect(page).to have_content("Email can't be blank")
  end
end
