require 'rails_helper'

RSpec.describe 'merchant navigation' do

  describe 'merchant nav bar approved pathways' do
    it 'includes links: return to welcome page, browse all items, see all merchants, my shopping cart, log in, user registration page, and profile page' do
      @merchant = User.create!(name: 'Joel Billy',
                              address: '125 Song St.',
                              city: 'Las Vegas',
                              state: 'NV',
                              zip: '12345',
                              email: 'billy_j@merchant.com',
                              password: '123',
                              role: 1)

      visit '/login'
      fill_in :email, with: @merchant.email
      fill_in :password, with: @merchant.password

      click_button "Log in"

      expect(current_path).to eq('/merchant/dashboard')

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
        expect(page).to have_link("All Items", href: "/items")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("Cart: 0", href: "/cart")
        expect(page).to have_link("My Profile", href: "/profile")
        expect(page).to have_link("Log out", href: "/logout")
        expect(page).to have_link("Dashboard", href: "/merchant/dashboard")
      end

      expect(page).to have_content "Logged in as #{@merchant.name}"
    end
  end

  describe 'merchant restricted pathways' do
    it 'merchant cannot access pathways designated for admins' do
      visit '/admin'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
