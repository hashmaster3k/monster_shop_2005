require 'rails_helper'

RSpec.describe 'user navigation' do

  describe 'user nav bar approved pathways' do
    it 'includes links: return to welcome page, browse all items, see all merchants, my shopping cart, log in, user registration page, and profile page' do
      @user = User.create!(name: 'Billy Joel',
                          address: '123 Song St.',
                          city: 'Las Vegas',
                          state: 'NV',
                          zip: '12345',
                          email: 'billy_j@user.com',
                          password: '123',
                          role: 0)

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: '123'

      click_button "Log in"

      expect(current_path).to eq('/profile')

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
        expect(page).to have_link("All Items", href: "/items")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("Cart: 0", href: "/cart")
        expect(page).to have_link("My Profile", href: "/profile")
        expect(page).to have_link("Log out", href: "/logout")
      end

      expect(page).to have_content "Logged in as #{@user.name}"
    end
  end

  describe 'user restricted pathways' do
    it 'user cannot access pathways designated for merchants or admins' do
      visit '/merchant'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
