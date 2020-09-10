require 'rails_helper'

RSpec.describe 'admin navigation' do

  describe 'admin nav bar approved pathways' do
    it 'includes links: return to welcome page, browse all items, see all merchants, my shopping cart, log in, user registration page, and profile page' do
      @admin = User.create!(name: 'Chilly Billy',
                            address: '125 Song St.',
                            city: 'Las Vegas',
                            state: 'NV',
                            zip: '12345',
                            email: 'chilly_b@admin.com',
                            password: '123',
                            role: 2)

      visit '/login'
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button "Log in"

      expect(current_path).to eq('/admin/dashboard')

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
        expect(page).to have_link("All Items", href: "/items")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("My Profile", href: "/profile")
        expect(page).to have_link("Log out", href: "/logout")
        expect(page).to have_link("Dashboard", href: "/admin/dashboard")
        expect(page).to have_link("All Users", href: "/admin/users")
      end

      expect(page).to have_content "Logged in as #{@admin.name}"
    end
  end

  describe 'admin restricted pathways' do
    it 'admin cannot access pathways designated for merchants or shopping carts' do
      @admin = User.create!(name: 'Chilly Billy',
                            address: '125 Song St.',
                            city: 'Las Vegas',
                            state: 'NV',
                            zip: '12345',
                            email: 'chilly_b@admin.com',
                            password: '123',
                            role: 2)

      visit '/login'
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button "Log in"

      visit '/merchant'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/cart'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
