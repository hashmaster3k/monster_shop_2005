require 'rails_helper'

RSpec.describe 'visitor navigation' do

  describe 'visitor nav bar approved pathways' do
    it 'includes links: return to welcome page, browse all items, see all merchants, my shopping cart, log in, user registration page' do
      visit '/merchants'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
        expect(page).to have_link("All Items", href: "/items")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("Cart: 0", href: "/cart")
        expect(page).to have_link("Log in", href: "/login")
        expect(page).to have_link("Register", href: "/register")
      end
    end
  end

  describe 'visitor restricted pathways' do
    it 'visitor cannot access pathways designated for users, merchants, or admins' do
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

      visit '/profile'

      within '.topnav' do
        expect(page).to have_link("Home Page", href: "/")
      end

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
