require 'rails_helper'

RSpec.describe 'SESSIONS DELETE' do
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

  describe 'a logged in user can log out' do
    it 'can log in and see their profile page' do
    visit '/login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password

    click_button 'Log in'

    within '.topnav' do
      click_link 'Log out'
    end

    expect(current_path).to eq('/login')
    expect(page).to have_content("Successfully logged out")
    end

    it 'clears cart when logging out' do
      bike_shop = Merchant.create(name: "Meg's Bike Shop",
                                  address: '123 Bike Rd.',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80203)

      tire = bike_shop.items.create(name: "Gatorskins",
                                  description: "They'll never pop!",
                                  price: 100,
                                  image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
                                  inventory: 12)
      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button 'Log in'

      visit "/items/#{tire.id}"

      click_button 'Add To Cart'

      within '.topnav' do
        click_link 'Log out'
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
