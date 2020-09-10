require "rails_helper"

RSpec.describe "User show page" do
  before :each do
    @user = User.create!(name: 'Billy Joel',
      address: '123 Song St.',
      city: 'Las Vegas',
      state: 'NV',
      zip: '12345',
      email: 'billy_j@user.com',
      password: '123',
      role: 0)
  end

  it "I see all of my profile data on the page except my password" do

    visit "/login"

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password

    click_button "Log in"

    expect(current_path).to eq('/profile')

    within ".user_info"do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
    end
  end

  it "I see a link to edit my profile data" do
    visit "/login"

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password

    click_button "Log in"

    expect(page).to have_link("Edit Profile Information")
  end
end
